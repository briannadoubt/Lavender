//
//  SearchView.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/26/24.
//

import SwiftUI
import SwiftData

extension DeveloperToolsSupport.ColorResource: @unchecked Sendable {}
extension DeveloperToolsSupport.ImageResource: @unchecked Sendable {}

struct PodcastSearch: View, HasLogger {
    @Environment(\.modelContext) private var modelContext

    @State private var query: String = ""
    @State private var searchResults: [Podcast.SearchResult] = []

    @MainActor
    func performSearch() async {
        guard query.count > 2 else { return }
        let itunes = iTunesAPI()
        do {
            let result = try await itunes.search(term: query)
            self.searchResults = result.results
        } catch {
            Self.logger.error("Failed to search for \"\(query)\" with error: \"\(error)\"")
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { searchResult in
                    PodcastRow(podcast: Podcast(searchResult))
                }
            }
            .navigationTitle(LavenderScreen.search.title)
            .listStyle(.plain)
            .searchDictationBehavior(.inline(activation: .onLook))
            .searchable(
                text: $query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("Search for your favorite Podcasts, Audiobooks, and More")
            )
            .onChange(of: query, debounceTime: .seconds(0.5)) { newQuery in
                await performSearch()
            }
        }
    }
}

extension View {

    /// Adds a modifier for this view that fires an action only when a specified `debounceTime` elapses between value
    /// changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - duration: The time to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    @available(visionOS 1.0, *)
    public func onChange<Value: Sendable>(
        of value: Value,
        debounceTime: Duration,
        perform action: @escaping @MainActor (_ newValue: Value) async -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChangeViewModifier(trigger: value, action: action) {
            try await Task.sleep(for: debounceTime)
        })
    }

    /// Adds a modifier for this view that fires an action only when a time interval in seconds represented by
    /// `debounceTime` elapses between value changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime` in seconds.
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether to run the closure.
    ///   - debounceTime: The time in seconds to wait after each value change before running `action` closure.
    ///   - action: A closure to run when the value changes.
    /// - Returns: A view that fires an action after debounced time when the specified value changes.
    @available(iOS, deprecated: 16.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(macOS, deprecated: 13.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(tvOS, deprecated: 16.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(watchOS, deprecated: 9.0, message: "Use version of this method accepting Duration type as debounceTime")
    @available(visionOS, deprecated: 1.0, message: "Use version of this method accepting Duration type as debounceTime")
    public func onChange<Value: Sendable>(
        of value: Value,
        debounceTime: TimeInterval,
        perform action: @escaping (_ newValue: Value) -> Void
    ) -> some View where Value: Equatable {
        self.modifier(DebouncedChangeViewModifier(trigger: value, action: action) {
            try await Task.sleep(seconds: debounceTime)
        })
    }
}

private struct DebouncedChangeViewModifier<Value: Sendable>: ViewModifier where Value: Equatable {
    let trigger: Value
    let action: (Value) async -> Void
    let sleep: @Sendable () async throws -> Void

    @State private var debouncedTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content.onChange(of: trigger) { _, value in
            debouncedTask?.cancel()
            debouncedTask = Task {
                do { try await sleep() } catch { return }
                await action(value)
            }
        }
    }
}

extension View {

    /// Adds a task to perform before this view appears or when a specified value changes and a specified
    /// `debounceTime` elapses between value changes.
    ///
    /// Each time the value changes before `debounceTime` passes, the previous action will be cancelled and the next
    /// action will be scheduled to run after that time passes again. This mean that the action will only execute
    /// after changes to the value stay unmodified for the specified `debounceTime`.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes. The value must conform to the `Equatable` protocol.
    ///   - duration: The time to wait after each value change before running `action` closure.
    ///   - action: A closure called after debounce time as an asynchronous task before the view appears. SwiftUI can
    ///     automatically cancel the task after the view disappears before the action completes. If the id value
    ///     changes, SwiftUI cancels and restarts the task.
    /// - Returns: A view that runs the specified action asynchronously before the view appears, or restarts the task
    ///     with the id value changes after debounced time.
    @available(iOS 16.0, *)
    @available(macOS 13.0, *)
    @available(tvOS 16.0, *)
    @available(watchOS 9.0, *)
    @available(visionOS 1.0, *)
    public func task<T>(
        id value: T,
        priority: TaskPriority = .userInitiated,
        debounceTime: Duration,
        _ action: @escaping @Sendable () async -> Void
    ) -> some View where T: Equatable {
        self.task(id: value, priority: priority) {
            do { try await Task.sleep(for: debounceTime) } catch { return }
            await action()
        }
    }
}

extension Task {

    /// Asynchronously runs the given `operation` in its own task after the specified number of `seconds`.
    ///
    /// The operation will be executed after specified number of `seconds` passes. You can cancel the task earlier
    /// for the operation to be skipped.
    ///
    /// - Parameters:
    ///   - time: Delay time in seconds.
    ///   - operation: The operation to execute.
    /// - Returns: Handle to the task which can be cancelled.
    @discardableResult
    public static func delayed(
        seconds: TimeInterval,
        operation: @escaping @Sendable () async -> Void
    ) -> Self where Success == Void, Failure == Never {
        Self {
            do {
                try await Task<Never, Never>.sleep(seconds: seconds)
                await operation()
            } catch {}
        }
    }

    static func sleep(seconds: TimeInterval) async throws where Success == Never, Failure == Never {
        try await Task<Success, Failure>.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

#Preview {
    PodcastSearch()
}
