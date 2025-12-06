//
//  ExerciseDetailView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    let primaryMuscle: MuscleGroup?
    let secondaryMuscles: [MuscleGroup]
    @Environment(\.dismiss) private var dismiss
    @State private var sets: Int
    @State private var reps: Int
    @State private var load: String
    
    init(exercise: Exercise, primaryMuscle: MuscleGroup? = nil, secondaryMuscles: [MuscleGroup] = []) {
        self.exercise = exercise
        self.primaryMuscle = primaryMuscle
        self.secondaryMuscles = secondaryMuscles
        _sets = State(initialValue: exercise.sets)
        _reps = State(initialValue: exercise.reps)
        _load = State(initialValue: "")
    }
    
    // Generate contextual instructions based on exercise name
    private var instructions: [String] {
        let name = exercise.name.lowercased()
        
        if name.contains("press") {
            return [
                "Set up in the proper starting position for the exercise",
                "Engage your core and maintain proper posture throughout",
                "Press the weight away from your body with controlled motion",
                "Focus on the target muscle group during each repetition",
                "Complete the full range of motion for maximum effectiveness"
            ]
        } else if name.contains("squat") {
            return [
                "Stand with feet shoulder-width apart, toes slightly pointed out",
                "Engage your core and keep your chest up throughout",
                "Lower your body by bending at the knees and hips",
                "Descend until thighs are parallel to the floor or lower",
                "Drive through your heels to return to the starting position"
            ]
        } else if name.contains("curl") {
            return [
                "Stand or sit with arms at your sides, holding weights",
                "Keep your elbows close to your body and core engaged",
                "Curl the weights upward by flexing your biceps",
                "Squeeze at the top of the movement",
                "Lower the weights slowly with control to the starting position"
            ]
        } else if name.contains("plank") {
            return [
                "Start in a push-up position with arms straight",
                "Engage your core and keep your body in a straight line",
                "Hold the position while maintaining proper form",
                "Keep your head, shoulders, hips, and ankles aligned",
                "Breathe steadily throughout the hold"
            ]
        } else {
            return [
                "Set up in the proper starting position for the exercise",
                "Engage your core and maintain proper posture throughout",
                "Perform the movement with controlled, deliberate motion",
                "Focus on the target muscle group during each repetition",
                "Complete the full range of motion for maximum effectiveness"
            ]
        }
    }
    
    // Determine equipment from exercise name
    private var equipment: [String] {
        let name = exercise.name.lowercased()
        var equip: [String] = []
        
        if name.contains("barbell") {
            equip.append("Barbell")
        }
        if name.contains("dumbbell") || name.contains("db ") {
            equip.append("Dumbbell")
        }
        if name.contains("cable") {
            equip.append("Cable Machine")
        }
        if name.contains("bodyweight") || name.contains("push-up") || name.contains("pushup") || name.contains("plank") {
            equip.append("Bodyweight")
        }
        if name.contains("mat") {
            equip.append("Mat")
        }
        
        if equip.isEmpty {
            equip.append("Bodyweight")
        }
        
        return equip
    }
    
    // Determine muscles from exercise name
    private var muscles: [String] {
        let name = exercise.name.lowercased()
        var muscleGroups: [String] = []
        
        if name.contains("chest") || name.contains("bench") || name.contains("press") || name.contains("push") {
            muscleGroups.append("Chest")
        }
        if name.contains("bicep") || name.contains("curl") {
            muscleGroups.append("Biceps")
        }
        if name.contains("tricep") || name.contains("extension") || name.contains("dip") {
            muscleGroups.append("Triceps")
        }
        if name.contains("shoulder") || name.contains("deltoid") {
            muscleGroups.append("Shoulders")
        }
        if name.contains("back") || name.contains("row") || name.contains("pull") {
            muscleGroups.append("Back")
        }
        if name.contains("leg") || name.contains("squat") || name.contains("quad") {
            muscleGroups.append("Legs")
        }
        if name.contains("abs") || name.contains("core") || name.contains("plank") {
            muscleGroups.append("Abs")
        }
        
        if muscleGroups.isEmpty {
            muscleGroups.append("Full Body")
        }
        
        return muscleGroups
    }
    
    // Check if bodyweight exercise
    private var isBodyweight: Bool {
        equipment.contains { $0.lowercased() == "bodyweight" }
    }
    
    // Muscle-specific overlay view builder
    @ViewBuilder
    private func muscleOverlay(for muscle: MuscleGroup) -> some View {
        switch muscle {
        case .chest:
            // Chest region overlay - positioned over pecs
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "FF3B30").opacity(0.35))
                .frame(width: 140, height: 80)
                .offset(y: -40)
                .blur(radius: 10)
            
        case .abs:
            // Abs region overlay - positioned over core
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "FF3B30").opacity(0.35))
                .frame(width: 100, height: 60)
                .offset(y: 20)
                .blur(radius: 8)
            
        case .biceps:
            // Biceps overlay - positioned on arms
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 50, height: 100)
                    .offset(x: -50, y: 10)
                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 50, height: 100)
                    .offset(x: 50, y: 10)
                    .blur(radius: 8)
            }
            
        case .shoulders:
            // Shoulders overlay - positioned on shoulders
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 60, height: 80)
                    .offset(x: -60, y: -60)
                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 60, height: 80)
                    .offset(x: 60, y: -60)
                    .blur(radius: 8)
            }
            
        case .obliques:
            // Obliques overlay - positioned on sides
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 40, height: 100)
                    .offset(x: -70, y: 10)
                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 40, height: 100)
                    .offset(x: 70, y: 10)
                    .blur(radius: 8)
            }
            
        case .forearms:
            // Forearms overlay - positioned on lower arms
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 35, height: 80)
                    .offset(x: -55, y: 50)
                    .blur(radius: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(hex: "FF3B30").opacity(0.35))
                    .frame(width: 35, height: 80)
                    .offset(x: 55, y: 50)
                    .blur(radius: 8)
            }
        }
    }
    
    // Secondary muscle highlights (for future use - orange overlays)
    private var secondaryMuscleHighlights: [String] {
        // Placeholder array - structure ready for future orange overlays
        // When ready, map secondaryMuscles to highlight image names
        return []
    }
    
    // Get primary muscle display name
    private var primaryMuscleName: String {
        guard let muscle = primaryMuscle else {
            // Fallback to name-based detection if no muscle provided
            return muscles.first ?? "Full Body"
        }
        
        switch muscle {
        case .chest:
            return "Chest"
        case .abs:
            return "Abs"
        case .biceps:
            return "Biceps"
        case .shoulders:
            return "Shoulders"
        case .obliques:
            return "Obliques"
        case .forearms:
            return "Forearms"
        }
    }
    
    // Get secondary muscle display names
    private var secondaryMuscleNames: [String] {
        if !secondaryMuscles.isEmpty {
            return secondaryMuscles.map { muscle in
                switch muscle {
                case .chest:
                    return "Chest"
                case .abs:
                    return "Abs"
                case .biceps:
                    return "Biceps"
                case .shoulders:
                    return "Shoulders"
                case .obliques:
                    return "Obliques"
                case .forearms:
                    return "Forearms"
                }
            }
        } else {
            // Fallback to name-based detection
            return Array(muscles.dropFirst())
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 16) {
                        Button(action: {
                            HapticFeedback.impact(style: .light)
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "1C1C1E"))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: "F2F2F7"))
                                .clipShape(Circle())
                        }
                        
                        Text(exercise.name)
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    
                    // Video Section - Clean Card Design
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "F2F2F7"))
                                .aspectRatio(16/9, contentMode: .fit)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                            
                            VStack(spacing: 12) {
                                Button(action: {}) {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color(hex: "FF3B30"))
                                }
                                
                                Text("Video coming soon")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color(hex: "6E6E73"))
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // How to Perform - Improved Spacing
                    VStack(alignment: .leading, spacing: 20) {
                        Text("How to Perform")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(Array(instructions.enumerated()), id: \.offset) { index, instruction in
                                HStack(alignment: .top, spacing: 16) {
                                    Text("\(index + 1)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Color(hex: "FF3B30"))
                                        .clipShape(Circle())
                                    
                                    Text(instruction)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "1C1C1E"))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineSpacing(4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Equipment Needed - Clean Badge (Left Aligned)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Equipment Needed")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        HStack(alignment: .top, spacing: 8) {
                            ForEach(equipment, id: \.self) { equip in
                                HStack(spacing: 8) {
                                    Image(systemName: equip.lowercased() == "bodyweight" ? "figure.walk" : "dumbbell.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(hex: "FF3B30"))
                                    
                                    Text(equip)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "1C1C1E"))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(hex: "F2F2F7"))
                                .cornerRadius(16)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Muscles Targeted - Using Real 3D Anatomy Model Assets
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Muscles Targeted")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        // Anatomy Model Container with Layered Assets
                        ZStack {
                            // Container background
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "F2F2F7"))
                                .frame(height: 280)
                            
                            // Base layer: Grayscale anatomy model
                            Image("body-front")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 260)
                                .grayscale(0.4)
                                .opacity(0.9)
                            
                            // Overlay layer: Primary muscle highlight (muscle-specific)
                            if let muscle = primaryMuscle {
                                muscleOverlay(for: muscle)
                            }
                            
                            // Future: Secondary muscle highlights (orange overlays)
                            // For now, secondaryMuscles array is empty
                            // Structure ready for: ForEach(secondaryMuscles, id: \.self) { muscle in muscleOverlay(for: muscle, color: .orange) }
                        }
                        .padding(18)
                        .padding(.bottom, 16)
                        
                        // Muscle Tags - Primary and Secondary
                        HStack(alignment: .top, spacing: 8) {
                            // Primary muscle badge (red)
                            if primaryMuscle != nil {
                                Text(primaryMuscleName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "FF3B30"))
                                    .cornerRadius(16)
                            } else if !muscles.isEmpty {
                                // Fallback to name-based detection
                                Text(muscles.first ?? "Full Body")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "FF3B30"))
                                    .cornerRadius(16)
                            }
                            
                            // Secondary muscle badges (gray)
                            ForEach(secondaryMuscleNames, id: \.self) { muscle in
                                Text(muscle)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(hex: "6E6E73"))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "F2F2F7"))
                                    .cornerRadius(16)
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                    
                    // Your Working Sets - Cleaner Card Design
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Working Sets")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                        
                        VStack(spacing: 0) {
                            // Sets Row
                            HStack {
                                HStack(spacing: 10) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "FF3B30"))
                                    
                                    Text("Sets")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color(hex: "1C1C1E"))
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        HapticFeedback.impact(style: .light)
                                        if sets > 1 {
                                            sets -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color(hex: "C7C7CC"))
                                    }
                                    
                                    Text("\(sets)")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "1C1C1E"))
                                        .frame(minWidth: 32)
                                    
                                    Button(action: {
                                        HapticFeedback.impact(style: .light)
                                        sets += 1
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(Color(hex: "C7C7CC"))
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            
                            // Divider
                            Rectangle()
                                .fill(Color(hex: "EEEEEE"))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                            
                            // Reps Row
                            HStack {
                                Text("Reps")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "1C1C1E"))
                                
                                Spacer()
                                
                                TextField("10-12", value: $reps, format: .number)
                                    .keyboardType(.numberPad)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(hex: "1C1C1E"))
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 100)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "F2F2F7"))
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(Color.white)
                            
                            // Divider
                            Rectangle()
                                .fill(Color(hex: "EEEEEE"))
                                .frame(height: 1)
                                .padding(.horizontal, 20)
                            
                            // Load Row
                            HStack {
                                Text("Load")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(Color(hex: "1C1C1E"))
                                
                                Spacer()
                                
                                if isBodyweight {
                                    Text("Bodyweight")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "6E6E73"))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "F2F2F7"))
                                        .cornerRadius(10)
                                } else {
                                    TextField("Weight", text: $load)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(Color(hex: "1C1C1E"))
                                        .multilineTextAlignment(.trailing)
                                        .frame(width: 120)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(Color(hex: "F2F2F7"))
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(Color.white)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
            }
            
            // Fixed Bottom Button
            Button(action: {
                HapticFeedback.impact(style: .medium)
                dismiss()
            }) {
                Text("Save Changes")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "FF3B30"))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ExerciseDetailView(
        exercise: Exercise(
            name: "Push-ups",
            sets: 3,
            reps: 12,
            restSeconds: 60,
            instructions: "Start in plank position, lower your body until chest nearly touches floor, then push back up."
        ),
        primaryMuscle: .chest,
        secondaryMuscles: []
    )
}
