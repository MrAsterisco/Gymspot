//
//  WorkoutView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 17.05.22.
//

import SwiftUI
import GymspotKit

struct WorkoutView: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  let workoutId: String
  
  @StateObject private var viewModel = WorkoutViewModel()
  @State private var isEditingValue = false
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          GroupBox {
            if let currentStep = viewModel.currentStep {
              viewModel.generateCell(forCurrentStep: currentStep, editCallback: edit(value:))
            } else {
              Text("No current step")
                .foregroundColor(.secondary)
            }
          }
          .padding([.leading, .trailing])
          
          switch viewModel.exerciseInteraction {
          case .skipAndNext:
            HStack {
              Button(action: viewModel.skipStep) {
                Text("Skip")
                  .foregroundColor(.primary)
                  .frame(maxWidth: .infinity)
              }
              .buttonStyle(.bordered)
              
              Button(action: viewModel.nextStep) {
                Text("Next")
                  .bold()
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
              }
              .tint(Color("Start"))
              .buttonStyle(.borderedProminent)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            
          case .time:
            HStack {
              Button(action: viewModel.increaseTimer) {
                Text("+15s")
                  .foregroundColor(.primary)
              }
              .buttonStyle(.bordered)
              
              Button(action: viewModel.skipStep) {
                Text("Skip")
                  .bold()
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
              }
              .tint(Color("Start"))
              .buttonStyle(.borderedProminent)
              
              Button(action: viewModel.decreaseTimer) {
                Text("-15s")
                  .foregroundColor(.primary)
              }
              .buttonStyle(.bordered)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing])
            
          case .finish:
            Button(action: finishWorkout) {
              Text("Finish")
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            .tint(Color("Start"))
            .buttonStyle(.borderedProminent)
            .padding([.leading, .trailing])
          
          case .none:
            Spacer()
          }
          
          Spacer()
            .frame(height: 20)
          
          if !viewModel.nextSteps.isEmpty {
            GroupBox("Next Up") {
              LazyVStack {
                ForEach($viewModel.nextSteps) { $step in
                  viewModel.generateCell(forNextUpStep: step)
                }
              }
            }
            .padding([.leading, .trailing])
          }
        }
      }
      .navigationTitle(viewModel.workout?.name ?? "Workout")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.down")
          }
        }
        
        ToolbarItemGroup(placement: .bottomBar) {
          if viewModel.canPlay {
            Button(action: viewModel.playWorkout) {
              Image(systemName: "play.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.title)
                .foregroundColor(Color("Start"))
            }
          }
          
          if viewModel.canPause {
            Button(action: viewModel.pauseWorkout) {
              Image(systemName: "pause.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.title)
                .foregroundColor(Color("Pause"))
            }
          }
          
          if viewModel.canStop {
            Button(action: viewModel.stopWorkout) {
              Image(systemName: "stop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.title)
                .foregroundColor(.red)
            }
          }
          
          if viewModel.canRestart {
            Button(action: viewModel.restartWorkout) {
              Image(systemName: "arrow.counterclockwise.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.title)
                .foregroundColor(Color.secondary)
            }
          }
          
          Spacer()
          
          Text(viewModel.currentTime)
            .font(.title)
            .fontWeight(.semibold)
        }
      }
      .onAppear {
        viewModel.load(workout: workoutId)
      }
      .popover(isPresented: $isEditingValue) {
        NavigationView {
          List {
            Section(viewModel.editedValueType?.localizedName ?? "") {
              TextField("Value", text: $viewModel.editedValue)
                .keyboardType(.decimalPad)
            }
            
            Section(content: {
              Toggle("Update Routine", isOn: $viewModel.editingUpdatesRoutine)
              
            }, header: {
              Text("Routine")
            }) {
              Text("If this option is turned on, your routine will be updated with the new value. Otherwise, this change will only be applied to the current workout.")
            }
          }
          .navigationBarTitle("Update Value")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem.init(placement: .primaryAction) {
              Button(action: saveEdit) {
                Text("Save")
                  .bold()
              }
            }
            
            ToolbarItem.init(placement: .cancellationAction) {
              Button(action: { isEditingValue.toggle() }) {
                Text("Cancel")
              }
            }
          }
        }
      }
    }
  }
}

private extension WorkoutView {
  func edit(value: ValueType) {
    isEditingValue.toggle()
    viewModel.beginEditingCurrentStep(valueType: value)
  }
  
  func saveEdit() {
    viewModel.updateCurrentStep()
    isEditingValue.toggle()
  }
  
  func finishWorkout() {
    viewModel.nextStep()
    presentationMode.wrappedValue.dismiss()
  }
}

// MARK: - Preview
struct WorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    mock {
      WorkoutView(workoutId: "0")
    }
  }
}
