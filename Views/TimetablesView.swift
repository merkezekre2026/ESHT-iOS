import SwiftUI

struct TimetablesView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: TimetablesViewModel

    init() {
        _viewModel = StateObject(wrappedValue: TimetablesViewModel(repository: AppContext.makeDefault().repository))
    }

    var body: some View {
        VStack {
            Picker("Gün", selection: $viewModel.selectedDay) {
                ForEach(TimetableEntry.DayType.allCases, id: \.self) { day in
                    Text(day.rawValue).tag(day)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            List(viewModel.filtered) { entry in
                VStack(alignment: .leading) {
                    Text("Hat: \(entry.lineID) • Durak: \(entry.stopID)")
                        .font(.headline)
                    Text(entry.departures.prefix(10).joined(separator: "  "))
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Saatler")
        .task { await viewModel.load() }
    }
}
