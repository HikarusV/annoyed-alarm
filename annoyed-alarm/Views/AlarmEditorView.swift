import SwiftUI

struct AlarmEditorView: View {
    @Environment(\.dismiss) var dismiss
    var onDone: (() -> Void)? = nil
    
    let alarm: AlarmData?
    
    @StateObject private var vm = AlarmEditorViewModel()
    @State private var showDifficultyPicker = false
    
    init(alarm: AlarmData? = nil, onDone: (() -> Void)? = nil) {
        self.alarm = alarm
        self.onDone = onDone               // <-- simpan callback
        _vm = StateObject(wrappedValue: AlarmEditorViewModel(alarm: alarm))
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // MARK: - Top Bar
                HStack {
                    // Close Button
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.surface500)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(alarm == nil ? "Add Alarm" : "Edit Alarm")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    // Save Button (Check)
                    Button(action: {
                        vm.save()
                        onDone?()
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.accent500)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Time Picker
                DatePicker("", selection: $vm.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .frame(maxHeight: 180)
                
                // MARK: - Settings Card
                VStack(spacing: 0) {
                    
                    // Difficulty Row as Button
                    Button {
                        showDifficultyPicker = true
                    } label: {
                        HStack {
                            Text("Difficulty")
                                .foregroundColor(.textPrimary)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Text(vm.difficulty)
                                    .foregroundColor(.textSecondary)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.textSecondary)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                        }
                        .padding()
                    }
                    
                    Divider()
                        .background(Color.borderSubtle)
                    
                    // Name Row
                    HStack {
                        Text("Name")
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                        
                        TextField("Your Name", text: $vm.label)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.textPrimary)
                    }
                    .padding()
                }
                .background(Color.backgroundSecondary)
                .cornerRadius(16)
                .padding(.horizontal)
                
                // MARK: - Delete Alarm Button
                if alarm != nil {
                    Button(action: {
                        vm.delete()
                        onDone?()
                        dismiss()
                    }) {
                        Text("Delete Alarm")
                            .foregroundColor(.error)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.surface500)
                            .cornerRadius(24)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding(.top, 20)
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
        }
        // MARK: - Difficulty Picker Sheet
        .sheet(isPresented: $showDifficultyPicker) {
            DifficultyPickerView(selected: $vm.difficulty)
        }
    }
}

struct DifficultyPickerView: View {
    @Binding var selected: String
    @Environment(\.dismiss) var dismiss
    
    let options = ["Easy", "Medium", "Hard"]
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                    
                    Spacer()
                    
                    Text("Difficulty")
                        .foregroundColor(.textPrimary)
                        .font(.system(size: 17, weight: .semibold))
                    
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.primary500)
                }
                .padding()
                
                Divider()
                    .background(Color.borderSubtle)
                
                // Options
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selected = option
                        } label: {
                            HStack {
                                Text(option)
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                if selected == option {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.primary500)
                                }
                            }
                            .padding()
                        }
                        
                        Divider()
                            .background(Color.borderSubtle)
                    }
                }
                .background(Color.backgroundSecondary)
                .cornerRadius(16)
                .padding()
                
                Spacer()
            }
        }
    }
}
