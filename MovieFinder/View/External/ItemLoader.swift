//
//  AsyncItemLoader.swift
//  MovieFinder
//
//  Created by matt naples on 9/25/23.
//

import SwiftUI

import SwiftUI

public enum LoadingPhase<Item>{
    case initial
    case loading
    case loaded(Item)
    case error(Error)
    
    public var isLoading: Bool{
        if case .loading = self{
            return true
        }
        return false
    }
    public var isInErrorState: Bool{
        if case .error(_) = self{
            return true
        }
        return false
    }
    public var isInLoadedState: Bool{
        if case .loaded(_) = self{
            return true
        }
        return false
    }
}
class ItemLoaderViewModel<Item>: ObservableObject{
    public init( query: @escaping () async throws -> Item, callback: @escaping (LoadingPhase<Item>) -> Void){
        self.query = query
        self.callback = callback
    }
    let query: () async throws -> Item
    var callback: (LoadingPhase<Item>) -> Void
    
    @MainActor
    func load() async{
        callback(.loading)
            do{
                let items = try await self.query()
                self.callback(.loaded(items))
            } catch{
                self.callback(.error(error))
            }
    }
}

/**
 `AsyncItemLoader`  the logic for the common operation of asynchronously loading and displaying `Item`s. It lets you forget about when a view should display the items, an error, an initial loading state, or empty results.
 */
public struct ItemLoaderBase<Item, Content: View>: View {
    @ViewBuilder let content: (Action) -> Content
    @StateObject var viewModel: ItemLoaderViewModel<Item>
    //    let callback: (LoadingPhase<Item>) -> Void

    /**
     Creates an AsyncItemLoader
     
     - Parameters:
     - id: a keypath that uniquely identifies an item.
     - query: the loading operation
     - content: This is a view that specifies how to display the items in the collection
     - errorView: A closure to create a view that'll be displayed when an error occurred in loading items
     - progress: A closure to create a view that'll be displayed when the items are initially loading
     
     */
    public init(query: @escaping () async throws -> Item,callback: @escaping (LoadingPhase<Item>) -> Void,
                 @ViewBuilder content: @escaping (Action) -> Content
    ){
        self.content = content
        self._viewModel = StateObject(wrappedValue: ItemLoaderViewModel<Item>(query: query, callback: callback))
    }
    
    
    public var body: some View {
        
        
        content(Action(action: viewModel.load))
            .environment(\.refresh, Action(action: viewModel.load))
    }
}


public struct ItemLoader<Item, Content: View>: View{
    @State private var phase: LoadingPhase<Item> = .initial
    @ViewBuilder let content: (Action,LoadingPhase<Item>) -> Content
    let query: () async throws -> Item

    
    /**
     Creates an AsyncItemLoader
     
     - Parameters:
     - id: a keypath that uniquely identifies an item.
     - query: the loading operation
     - content: This is a view that specifies how to display the items in the collection
     - errorView: A closure to create a view that'll be displayed when an error occurred in loading items
     - progress: A closure to create a view that'll be displayed when the items are initially loading
     
     */
    public init( query: @escaping () async throws -> Item,
                @ViewBuilder content: @escaping (Action,LoadingPhase<Item>) -> Content
    ){
        self.query = query
        self.content = content
    }
    
    public var body: some View{
        ItemLoaderBase(query: self.query, callback: {self.phase = $0 }) { action in
            self.content(action, self.phase)
        }
    }
}


class FakeDataService{
    func searchData(query: String) async throws -> [String]{
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let characters = Array(query)
        return characters.map{String($0)}
    }
}

public struct Action {
    
    let action: () async -> Void
    public func callAsFunction() async {
        await action()
    }
}
struct ActionKey: EnvironmentKey {
    
    static let defaultValue: Action? = nil
}
extension EnvironmentValues {
 
    var refresh: Action? {
        get { self[ActionKey.self] }
        set { self[ActionKey.self] = newValue }
    }
    
    
//    var save2: GenericSaveActionKey?{
//        get { self[GenericSaveActionKey.self] }
//        set { self[GenericSaveActionKey.self] = newValue }    }
}
