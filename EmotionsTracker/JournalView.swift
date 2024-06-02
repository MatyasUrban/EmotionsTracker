import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.modelContext) private var context
    @State private var createNewEmotionLog = false
    @Query(sort: [SortDescriptor(\EmotionLog.datetime, order: .reverse)]) private var emotionLogs: [EmotionLog]
    var body: some View {
        NavigationStack {
            Group {
                if emotionLogs.isEmpty {
                    ContentUnavailableView("No emotions logged yet.", systemImage: "exclamationmark.triangle")
                } else {
                    List {
                        ForEach(emotionLogs) { log in
                            NavigationLink(destination: DetailView(emotionLog: log)) {
                                VStack(alignment: .leading) {
                                    Text("\(log.feeling) | \(log.emotion)")
                                        .font(.headline)
                                    Text("\(log.datetime, formatter: itemFormatter)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: deleteEmotionLog)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(for: EmotionLog.self) {
                emotionLog in
                Text(emotionLog.context)
            }
            .navigationTitle("Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button("Add Entry"){
                        createNewEmotionLog.toggle()
                    }
                    .sheet(isPresented: $createNewEmotionLog) {
                        AddView()
                    }
                }
            }
        }
    }
    
    private func deleteEmotionLog(at offsets: IndexSet) {
        offsets.forEach { index in
            let log = emotionLogs[index]
            context.delete(log)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    JournalView()
}
