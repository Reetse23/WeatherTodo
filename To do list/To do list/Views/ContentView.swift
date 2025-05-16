import SwiftUI
import CoreLocation
import RealmSwift

struct ContentView: View {
    @StateObject private var taskManager = TaskManager(storage: RealmTaskStorage())
    @StateObject private var weatherVM = WeatherViewModel()
    @StateObject private var locationManager: LocationManager
    
    @State private var isShowingTaskCreator = false
    @State private var selectedSegment = 0
    
    init() {
        let weatherVM = WeatherViewModel()
        _weatherVM = StateObject(wrappedValue: weatherVM)
        _locationManager = StateObject(wrappedValue: LocationManager(weatherVM: weatherVM))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                WeatherView(weatherVM: weatherVM)
                    .padding(.horizontal)
                Divider()
                
                Picker("Tasks", selection: $selectedSegment) {
                    Text("To Do").tag(0)
                    Text("Completed").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    ForEach(selectedSegment == 0 ? taskManager.todoTasks : taskManager.completedTasks) { task in
                        TaskRow(task: task) {
                            taskManager.toggleTaskCompletion(task)
                        } onDelete: {
                            taskManager.deleteTask(task)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .searchable(text: $taskManager.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingTaskCreator = true
                    } label: {
                        HStack {
                            Text("Add Task")
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .sheet(isPresented: $isShowingTaskCreator) {
                TaskCreatorView { task in
                    taskManager.addTask(task)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
