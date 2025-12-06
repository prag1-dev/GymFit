//
//  BodyPartRecommendationView.swift
//  Gym Fit
//
//  Created by Cursor on 11/16/25.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif

enum WorkoutMode: String, CaseIterable {
    case bodyMap = "Body Map"
    case simpleMode = "Simple Mode"
    case aiMode = "AI Mode"
}

enum GymType: String, CaseIterable {
    case homeBodyweight = "Home – Bodyweight"
    case homeDumbbells = "Home – Dumbbells"
    case commercialGym = "Commercial Gym"
    case hotelGym = "Hotel Gym"
    case custom = "Custom Gym Setup"
}

extension GymType {
    var gymProfile: GymProfile {
        switch self {
        case .homeBodyweight:
            return .homeBodyweight
        case .homeDumbbells:
            return .homeDumbbells
        case .hotelGym:
            return .hotel
        case .commercialGym:
            return .commercial
        case .custom:
            return .commercial // Default to commercial for custom setups
        }
    }
}

struct BodyPartRecommendationView: View {
    @State private var selectedMode: WorkoutMode = .bodyMap
    @State private var isFrontView: Bool = true
    @State private var selectedMuscleGroups: Set<String> = []
    @State private var selectedSimpleBodyPart: String? = nil
    @State private var selectedDuration: String = "30m"
    @State private var selectedIntensity: String = "Medium"
    @State private var selectedEquipment: String = "Dumbbells"
    @State private var selectedGoal: String = "Pump"
    @State private var aiWorkoutGenerated: Bool = false
    
    // New state for chips
    @State private var selectedTime: Int = 30
    @State private var selectedGymType: GymType = .homeBodyweight
    @State private var showTimeSheet = false
    @State private var showGymSheet = false
    @State private var showCustomTime = false
    @State private var customTimeValue: String = ""
    @State private var selectedMuscle: MuscleGroup? = nil
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedPrimaryMuscle: MuscleGroup? = nil
    @State private var selectedSecondaryMuscles: [MuscleGroup] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Workout")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Text("Choose your workout style")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Mode Selector
                ModeSelector(selectedMode: $selectedMode)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    .onChange(of: selectedMode) {
                        // Reset states when switching modes
                        selectedMuscleGroups = []
                        selectedSimpleBodyPart = nil
                        aiWorkoutGenerated = false
                    }
                
                // Time and Gym Selector Chips
                HStack(spacing: 12) {
                    TimeSelectorChip(
                        selectedTime: $selectedTime,
                        showSheet: $showTimeSheet
                    )
                    .frame(maxWidth: .infinity)
                    
                    GymSelectorChip(
                        selectedGymType: $selectedGymType,
                        showSheet: $showGymSheet
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Content based on selected mode
                Group {
                    switch selectedMode {
                    case .bodyMap:
                        bodyMapView
                    case .simpleMode:
                        simpleModeView
                    case .aiMode:
                        aiModeView
                    }
                }
                
                Spacer(minLength: 100)
            }
        }
        .background(Color.white)
        .sheet(isPresented: $showTimeSheet) {
            TimeSelectorSheet(
                selectedTime: $selectedTime,
                showCustomTime: $showCustomTime,
                customTimeValue: $customTimeValue,
                isPresented: $showTimeSheet
            )
        }
        .sheet(isPresented: $showGymSheet) {
            GymSelectorSheet(
                selectedGymType: $selectedGymType,
                isPresented: $showGymSheet
            )
        }
        #if os(iOS)
        .fullScreenCover(item: $selectedExercise) { exercise in
            ExerciseDetailView(
                exercise: exercise,
                primaryMuscle: selectedPrimaryMuscle,
                secondaryMuscles: selectedSecondaryMuscles
            )
        }
        #endif
    }
    
    // MARK: - Body Map Mode
    
    // MARK: - Body Map Mode Constants
    // Figma mannequin size
    private let originalWidth: CGFloat = 1024
    private let originalHeight: CGFloat = 1536
    
    // Figma chest values (top-left corner)
    private let chestX: CGFloat = 358  // Figma top-left X
    private let chestY: CGFloat = 303  // Figma top-left Y
    private let chestWidth: CGFloat = 308
    private let chestHeight: CGFloat = 144
    
    // Figma shoulder values (top-left corner)
    private let leftShoulderX: CGFloat = 290
    private let leftShoulderY: CGFloat = 237
    private let leftShoulderWidth: CGFloat = 171
    private let leftShoulderHeight: CGFloat = 204.5
    
    private let rightShoulderX: CGFloat = 561
    private let rightShoulderY: CGFloat = 238
    private let rightShoulderWidth: CGFloat = 173.11
    private let rightShoulderHeight: CGFloat = 203.5
    
    // Figma abs values (top-left corner)
    private let absX: CGFloat = 431
    private let absY: CGFloat = 432
    private let absWidth: CGFloat = 160.29
    private let absHeight: CGFloat = 231.65
    
    // Figma oblique values (top-left corner)
    private let leftObliqueX: CGFloat = 379.27
    private let leftObliqueY: CGFloat = 423
    private let leftObliqueWidth: CGFloat = 76.73
    private let leftObliqueHeight: CGFloat = 241.5
    
    private let rightObliqueX: CGFloat = 566
    private let rightObliqueY: CGFloat = 423
    private let rightObliqueWidth: CGFloat = 80.73
    private let rightObliqueHeight: CGFloat = 241.5
    
    // Figma bicep values (top-left corner)
    private let leftBicepX: CGFloat = 282.28
    private let leftBicepY: CGFloat = 390.89
    private let leftBicepWidth: CGFloat = 86.63
    private let leftBicepHeight: CGFloat = 176.61
    
    private let rightBicepX: CGFloat = 657
    private let rightBicepY: CGFloat = 390.87
    private let rightBicepWidth: CGFloat = 86.63
    private let rightBicepHeight: CGFloat = 179.63
    
    // Figma forearm values (top-left corner)
    private let leftForearmX: CGFloat = 208.5
    private let leftForearmY: CGFloat = 516.5
    private let leftForearmWidth: CGFloat = 126
    private let leftForearmHeight: CGFloat = 236.5
    
    private let rightForearmX: CGFloat = 690
    private let rightForearmY: CGFloat = 517
    private let rightForearmWidth: CGFloat = 126
    private let rightForearmHeight: CGFloat = 237.5
    
    // Figma quad values (top-left corner)
    private let leftQuadX: CGFloat = 354.5
    private let leftQuadY: CGFloat = 635.5
    private let leftQuadWidth: CGFloat = 154
    private let leftQuadHeight: CGFloat = 477.08
    
    private let rightQuadX: CGFloat = 516
    private let rightQuadY: CGFloat = 636
    private let rightQuadWidth: CGFloat = 154.05
    private let rightQuadHeight: CGFloat = 477.32
    
    // Figma tibialis values (top-left corner)
    private let leftTibialisX: CGFloat = 359
    private let leftTibialisY: CGFloat = 1064.5
    private let leftTibialisWidth: CGFloat = 113.5
    private let leftTibialisHeight: CGFloat = 352
    
    private let rightTibialisX: CGFloat = 549
    private let rightTibialisY: CGFloat = 1064.5
    private let rightTibialisWidth: CGFloat = 113.5
    private let rightTibialisHeight: CGFloat = 352
    
    // Convert Figma top-left to SwiftUI center coordinates
    private var chestCenterX: CGFloat {
        chestX + chestWidth / 2  // 358 + 154 = 512
    }
    private var chestCenterY: CGFloat {
        chestY + chestHeight / 2  // 303 + 72 = 375
    }
    
    private var bodyMapView: some View {
        VStack(spacing: 0) {
            // MARK: - Body Map Mannequin (Fixed Scaling)
            GeometryReader { geo in
                // GUARANTEED width (fallback if geo collapses)
                #if os(iOS)
                let screenWidth = max(geo.size.width, UIScreen.main.bounds.width)
#else
                let screenWidth = geo.size.width
#endif
                // Make mannequin slightly smaller (85% of available width)
                let containerWidth = (screenWidth - 48) * 0.85
                let scale = containerWidth / originalWidth
                
                // Calculate actual image size after scaling
                let aspectRatio = originalWidth / originalHeight
                let actualImageWidth = containerWidth
                let actualImageHeight = containerWidth / aspectRatio
                let actualScale = actualImageWidth / originalWidth
                
                // Figma base dimensions
                let figmaBaseWidth = originalWidth
                let figmaBaseHeight = originalHeight
                
                // Container dimensions
                let containerHeight = actualImageHeight
                
                // Scale factors
                let scaleX = containerWidth / figmaBaseWidth
                let scaleY = containerHeight / figmaBaseHeight
                
                // Scale SwiftUI center coordinates for chest
                let scaledChestCenterX = chestCenterX * actualScale
                let scaledChestCenterY = chestCenterY * actualScale
                let scaledChestWidth = chestWidth * actualScale
                let scaledChestHeight = chestHeight * actualScale
                
                // Left shoulder transform
                let leftShoulderScaledWidth = leftShoulderWidth * scaleX
                let leftShoulderScaledHeight = leftShoulderHeight * scaleY
                let leftShoulderCenterX = (leftShoulderX + leftShoulderWidth / 2) * scaleX
                let leftShoulderCenterY = (leftShoulderY + leftShoulderHeight / 2) * scaleY
                
                // Right shoulder transform
                let rightShoulderScaledWidth = rightShoulderWidth * scaleX
                let rightShoulderScaledHeight = rightShoulderHeight * scaleY
                let rightShoulderCenterX = (rightShoulderX + rightShoulderWidth / 2) * scaleX
                let rightShoulderCenterY = (rightShoulderY + rightShoulderHeight / 2) * scaleY
                
                // Abs transform
                let absScaledWidth = absWidth * scaleX
                let absScaledHeight = absHeight * scaleY
                let absCenterX = (absX + absWidth / 2) * scaleX
                let absCenterY = (absY + absHeight / 2) * scaleY
                
                // Left oblique transform
                let leftObliqueScaledWidth = leftObliqueWidth * scaleX
                let leftObliqueScaledHeight = leftObliqueHeight * scaleY
                let leftObliqueCenterX = (leftObliqueX + leftObliqueWidth / 2) * scaleX
                let leftObliqueCenterY = (leftObliqueY + leftObliqueHeight / 2) * scaleY
                
                // Right oblique transform
                let rightObliqueScaledWidth = rightObliqueWidth * scaleX
                let rightObliqueScaledHeight = rightObliqueHeight * scaleY
                let rightObliqueCenterX = (rightObliqueX + rightObliqueWidth / 2) * scaleX
                let rightObliqueCenterY = (rightObliqueY + rightObliqueHeight / 2) * scaleY
                
                // Left bicep transform
                let leftBicepScaledWidth = leftBicepWidth * scaleX
                let leftBicepScaledHeight = leftBicepHeight * scaleY
                let leftBicepCenterX = (leftBicepX + leftBicepWidth / 2) * scaleX
                let leftBicepCenterY = (leftBicepY + leftBicepHeight / 2) * scaleY
                
                // Right bicep transform
                let rightBicepScaledWidth = rightBicepWidth * scaleX
                let rightBicepScaledHeight = rightBicepHeight * scaleY
                let rightBicepCenterX = (rightBicepX + rightBicepWidth / 2) * scaleX
                let rightBicepCenterY = (rightBicepY + rightBicepHeight / 2) * scaleY
                
                // Left forearm transform
                let leftForearmScaledWidth = leftForearmWidth * scaleX
                let leftForearmScaledHeight = leftForearmHeight * scaleY
                let leftForearmCenterX = (leftForearmX + leftForearmWidth / 2) * scaleX
                let leftForearmCenterY = (leftForearmY + leftForearmHeight / 2) * scaleY
                
                // Right forearm transform
                let rightForearmScaledWidth = rightForearmWidth * scaleX
                let rightForearmScaledHeight = rightForearmHeight * scaleY
                let rightForearmCenterX = (rightForearmX + rightForearmWidth / 2) * scaleX
                let rightForearmCenterY = (rightForearmY + rightForearmHeight / 2) * scaleY
                
                // Left quad transform
                let leftQuadScaledWidth = leftQuadWidth * scaleX
                let leftQuadScaledHeight = leftQuadHeight * scaleY
                let leftQuadCenterX = (leftQuadX + leftQuadWidth / 2) * scaleX
                let leftQuadCenterY = (leftQuadY + leftQuadHeight / 2) * scaleY
                
                // Right quad transform
                let rightQuadScaledWidth = rightQuadWidth * scaleX
                let rightQuadScaledHeight = rightQuadHeight * scaleY
                let rightQuadCenterX = (rightQuadX + rightQuadWidth / 2) * scaleX
                let rightQuadCenterY = (rightQuadY + rightQuadHeight / 2) * scaleY
                
                // Left tibialis transform
                let leftTibialisScaledWidth = leftTibialisWidth * scaleX
                let leftTibialisScaledHeight = leftTibialisHeight * scaleY
                let leftTibialisCenterX = (leftTibialisX + leftTibialisWidth / 2) * scaleX
                let leftTibialisCenterY = (leftTibialisY + leftTibialisHeight / 2) * scaleY
                
                // Right tibialis transform
                let rightTibialisScaledWidth = rightTibialisWidth * scaleX
                let rightTibialisScaledHeight = rightTibialisHeight * scaleY
                let rightTibialisCenterX = (rightTibialisX + rightTibialisWidth / 2) * scaleX
                let rightTibialisCenterY = (rightTibialisY + rightTibialisHeight / 2) * scaleY
                
                HStack {
                    Spacer()
                    ZStack {
                        // Mannequin image - display only
                        Image(isFrontView ? "body-front" : "body-back")
                            .resizable()
                            .aspectRatio(aspectRatio, contentMode: .fit)
                            .frame(width: actualImageWidth, height: actualImageHeight)
                        
                        // Chest overlay - DISPLAY ONLY (no tap gesture here)
                        if isFrontView {
                            ChestShape()
                                .fill(selectedMuscleGroups.contains("chest") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: scaledChestWidth, height: scaledChestHeight)
                                .position(x: scaledChestCenterX, y: scaledChestCenterY)
                            
                            LeftShoulderShape()
                                .fill(selectedMuscleGroups.contains("shoulders") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftShoulderScaledWidth, height: leftShoulderScaledHeight)
                                .position(x: leftShoulderCenterX, y: leftShoulderCenterY)
                            
                            RightShoulderShape()
                                .fill(selectedMuscleGroups.contains("shoulders") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightShoulderScaledWidth, height: rightShoulderScaledHeight)
                                .position(x: rightShoulderCenterX, y: rightShoulderCenterY)
                            
                            AbsShape()
                                .fill(selectedMuscleGroups.contains("abs") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: absScaledWidth, height: absScaledHeight)
                                .position(x: absCenterX, y: absCenterY)
                            
                            LeftObliqueShape()
                                .fill(selectedMuscleGroups.contains("obliques") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftObliqueScaledWidth, height: leftObliqueScaledHeight)
                                .position(x: leftObliqueCenterX, y: leftObliqueCenterY)
                            
                            RightObliqueShape()
                                .fill(selectedMuscleGroups.contains("obliques") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightObliqueScaledWidth, height: rightObliqueScaledHeight)
                                .position(x: rightObliqueCenterX, y: rightObliqueCenterY)
                            
                            LeftBicepShape()
                                .fill(selectedMuscleGroups.contains("biceps") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftBicepScaledWidth, height: leftBicepScaledHeight)
                                .position(x: leftBicepCenterX, y: leftBicepCenterY)
                            
                            RightBicepShape()
                                .fill(selectedMuscleGroups.contains("biceps") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightBicepScaledWidth, height: rightBicepScaledHeight)
                                .position(x: rightBicepCenterX, y: rightBicepCenterY)
                            
                            LeftForearmShape()
                                .fill(selectedMuscleGroups.contains("forearms") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftForearmScaledWidth, height: leftForearmScaledHeight)
                                .position(x: leftForearmCenterX, y: leftForearmCenterY)
                            
                            RightForearmShape()
                                .fill(selectedMuscleGroups.contains("forearms") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightForearmScaledWidth, height: rightForearmScaledHeight)
                                .position(x: rightForearmCenterX, y: rightForearmCenterY)
                            
                            LeftQuadShape()
                                .fill(selectedMuscleGroups.contains("quads") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftQuadScaledWidth, height: leftQuadScaledHeight)
                                .position(x: leftQuadCenterX, y: leftQuadCenterY)
                            
                            RightQuadShape()
                                .fill(selectedMuscleGroups.contains("quads") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightQuadScaledWidth, height: rightQuadScaledHeight)
                                .position(x: rightQuadCenterX, y: rightQuadCenterY)
                            
                            LeftTibialisShape()
                                .fill(selectedMuscleGroups.contains("tibialis") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: leftTibialisScaledWidth, height: leftTibialisScaledHeight)
                                .position(x: leftTibialisCenterX, y: leftTibialisCenterY)
                            
                            RightTibialisShape()
                                .fill(selectedMuscleGroups.contains("tibialis") ? Color.red.opacity(0.35) : Color.clear)
                                .frame(width: rightTibialisScaledWidth, height: rightTibialisScaledHeight)
                                .position(x: rightTibialisCenterX, y: rightTibialisCenterY)
                        }
                    }
                    .frame(width: actualImageWidth, height: actualImageHeight)
                    Spacer()
                }
                .gesture(
                    // Manual bounding-box hit-testing (works correctly after scaling)
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            // Get the center offset (Spacers push content to center)
                            let totalWidth = geo.size.width
                            let imageOffsetX = (totalWidth - actualImageWidth) / 2
                            
                            // Convert tap location relative to the image (accounting for centering)
                            let relativeX = value.location.x - imageOffsetX
                            let relativeY = value.location.y
                            
                            // Only process taps within the image bounds
                            if relativeX >= 0 && relativeX <= actualImageWidth && relativeY >= 0 && relativeY <= actualImageHeight {
                                // Convert tap location from screen space to original Figma coordinates
                                let tapX = relativeX / actualScale
                                let tapY = relativeY / actualScale
                                
                                // Chest bounding rect in Figma coordinates (top-left origin)
                                let chestRect = CGRect(
                                    x: chestX,      // 358
                                    y: chestY,      // 303
                                    width: chestWidth,   // 308
                                    height: chestHeight // 144
                                )
                                
                                // Left shoulder bounding rect in Figma coordinates (top-left origin)
                                let leftShoulderRect = CGRect(
                                    x: leftShoulderX,
                                    y: leftShoulderY,
                                    width: leftShoulderWidth,
                                    height: leftShoulderHeight
                                )
                                
                                // Right shoulder bounding rect in Figma coordinates (top-left origin)
                                let rightShoulderRect = CGRect(
                                    x: rightShoulderX,
                                    y: rightShoulderY,
                                    width: rightShoulderWidth,
                                    height: rightShoulderHeight
                                )
                                
                                // Abs bounding rect in Figma coordinates (top-left origin)
                                let absRect = CGRect(
                                    x: absX,
                                    y: absY,
                                    width: absWidth,
                                    height: absHeight
                                )
                                
                                // Left oblique bounding rect in Figma coordinates (top-left origin)
                                let leftObliqueRect = CGRect(
                                    x: leftObliqueX,
                                    y: leftObliqueY,
                                    width: leftObliqueWidth,
                                    height: leftObliqueHeight
                                )
                                
                                // Right oblique bounding rect in Figma coordinates (top-left origin)
                                let rightObliqueRect = CGRect(
                                    x: rightObliqueX,
                                    y: rightObliqueY,
                                    width: rightObliqueWidth,
                                    height: rightObliqueHeight
                                )
                                
                                // Left bicep bounding rect in Figma coordinates (top-left origin)
                                let leftBicepRect = CGRect(
                                    x: leftBicepX,
                                    y: leftBicepY,
                                    width: leftBicepWidth,
                                    height: leftBicepHeight
                                )
                                
                                // Right bicep bounding rect in Figma coordinates (top-left origin)
                                let rightBicepRect = CGRect(
                                    x: rightBicepX,
                                    y: rightBicepY,
                                    width: rightBicepWidth,
                                    height: rightBicepHeight
                                )
                                
                                // Left forearm bounding rect in Figma coordinates (top-left origin)
                                let leftForearmRect = CGRect(
                                    x: leftForearmX,
                                    y: leftForearmY,
                                    width: leftForearmWidth,
                                    height: leftForearmHeight
                                )
                                
                                // Right forearm bounding rect in Figma coordinates (top-left origin)
                                let rightForearmRect = CGRect(
                                    x: rightForearmX,
                                    y: rightForearmY,
                                    width: rightForearmWidth,
                                    height: rightForearmHeight
                                )
                                
                                // Left quad bounding rect in Figma coordinates (top-left origin)
                                let leftQuadRect = CGRect(
                                    x: leftQuadX,
                                    y: leftQuadY,
                                    width: leftQuadWidth,
                                    height: leftQuadHeight
                                )
                                
                                // Right quad bounding rect in Figma coordinates (top-left origin)
                                let rightQuadRect = CGRect(
                                    x: rightQuadX,
                                    y: rightQuadY,
                                    width: rightQuadWidth,
                                    height: rightQuadHeight
                                )
                                
                                // Left tibialis bounding rect in Figma coordinates (top-left origin)
                                let leftTibialisRect = CGRect(
                                    x: leftTibialisX,
                                    y: leftTibialisY,
                                    width: leftTibialisWidth,
                                    height: leftTibialisHeight
                                )
                                
                                // Right tibialis bounding rect in Figma coordinates (top-left origin)
                                let rightTibialisRect = CGRect(
                                    x: rightTibialisX,
                                    y: rightTibialisY,
                                    width: rightTibialisWidth,
                                    height: rightTibialisHeight
                                )
                                
                                // Check if tap is inside chest bounding box
                                if chestRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("chest") {
                                            selectedMuscleGroups.remove("chest")
                                        } else {
                                            selectedMuscleGroups.insert("chest")
                                        }
                                    }
                                    print("Chest tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right shoulder bounding box
                                else if leftShoulderRect.contains(CGPoint(x: tapX, y: tapY)) || rightShoulderRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("shoulders") {
                                            selectedMuscleGroups.remove("shoulders")
                                        } else {
                                            selectedMuscleGroups.insert("shoulders")
                                        }
                                    }
                                    print("Shoulder tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside abs bounding box
                                else if absRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("abs") {
                                            selectedMuscleGroups.remove("abs")
                                        } else {
                                            selectedMuscleGroups.insert("abs")
                                        }
                                    }
                                    print("Abs tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right oblique bounding box
                                else if leftObliqueRect.contains(CGPoint(x: tapX, y: tapY)) || rightObliqueRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("obliques") {
                                            selectedMuscleGroups.remove("obliques")
                                        } else {
                                            selectedMuscleGroups.insert("obliques")
                                        }
                                    }
                                    print("Oblique tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right bicep bounding box
                                else if leftBicepRect.contains(CGPoint(x: tapX, y: tapY)) || rightBicepRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("biceps") {
                                            selectedMuscleGroups.remove("biceps")
                                        } else {
                                            selectedMuscleGroups.insert("biceps")
                                        }
                                    }
                                    print("Bicep tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right forearm bounding box
                                else if leftForearmRect.contains(CGPoint(x: tapX, y: tapY)) || rightForearmRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("forearms") {
                                            selectedMuscleGroups.remove("forearms")
                                        } else {
                                            selectedMuscleGroups.insert("forearms")
                                        }
                                    }
                                    print("Forearm tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right quad bounding box
                                else if leftQuadRect.contains(CGPoint(x: tapX, y: tapY)) || rightQuadRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("quads") {
                                            selectedMuscleGroups.remove("quads")
                                        } else {
                                            selectedMuscleGroups.insert("quads")
                                        }
                                    }
                                    print("Quad tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                                // Check if tap is inside left or right tibialis bounding box
                                else if leftTibialisRect.contains(CGPoint(x: tapX, y: tapY)) || rightTibialisRect.contains(CGPoint(x: tapX, y: tapY)) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if selectedMuscleGroups.contains("tibialis") {
                                            selectedMuscleGroups.remove("tibialis")
                                        } else {
                                            selectedMuscleGroups.insert("tibialis")
                                        }
                                    }
                                    print("Tibialis tapped! selectedMuscleGroups is now: \(selectedMuscleGroups)")
                                }
                            }
                        }
                )
            }
            #if os(iOS)
            .frame(height: originalHeight * (UIScreen.main.bounds.width - 48) * 0.85 / originalWidth)
            #else
            .aspectRatio(originalWidth / originalHeight, contentMode: .fit)
            #endif
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
            
            // Front/Back Toggle (below mannequin) - Bigger and moved up, centered
            HStack {
                Spacer()
                HStack(spacing: 0) {
                    ZStack {
                    // Background container - Capsule with padding (bigger)
                    Capsule()
                        .fill(Color(hex: "F3F4F6"))
                        .frame(width: 200)  // Increased from 160 to 200
                        .frame(height: 44)  // Increased from 34 to 44
                    
                    // Selected button background - fully rounded pill
                    GeometryReader { geo in
                        let buttonWidth = (geo.size.width - 10) / 2 // 5pt padding on each side
                        let buttonHeight = geo.size.height - 10
                        
                        Capsule()
                            .fill(Color(hex: "FF3B30"))
                            .frame(width: buttonWidth, height: buttonHeight)
                            .offset(x: isFrontView ? 5 : buttonWidth + 5, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFrontView)
                    }
                    
                    // Buttons - flex-1 (equal width), rounded-full, py-1.5
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isFrontView = true
                            }
                        }) {
                            Text("Front")
                                .font(.system(size: 16, weight: .medium))  // Increased from 14 to 16
                                .foregroundColor(isFrontView ? .white : Color(hex: "6B7280"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)  // Increased from 7 to 10
                        }
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                isFrontView = false
                            }
                        }) {
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))  // Increased from 14 to 16
                                .foregroundColor(!isFrontView ? .white : Color(hex: "6B7280"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)  // Increased from 7 to 10
                        }
                    }
                    .padding(5)  // Increased from 4 to 5
                }
                .frame(width: 200, height: 44)  // Updated to match new size
                }
                Spacer()
            }
            .padding(.bottom, 20)
            
            // Hint or Workouts
            if selectedMuscleGroups.isEmpty {
                Text("Tap a muscle group to see workouts")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "8E8E93"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            } else if selectedMuscleGroups.count == 1 {
                // Single muscle selected - show one combined section
                if let muscleGroup = selectedMuscleGroups.first,
                   let muscleData = workoutLibrary[muscleGroup] {
                    // Combine all workouts from all sections into one list
                    let allWorkouts = muscleData.sections.flatMap { $0.workouts }
                    let sectionTitle = muscleGroup.capitalized + " Workouts"
                    
                    WorkoutSectionView(
                        title: sectionTitle,
                        workouts: allWorkouts,
                        onExerciseTap: { workout in
                            let exercise = Exercise(
                                name: workout.name,
                                sets: extractSets(from: workout.sets),
                                reps: extractReps(from: workout.sets),
                                restSeconds: 60,
                                instructions: "Perform \(workout.name) with proper form."
                            )
                            
                            // Convert selected muscle groups to MuscleGroup enum
                            let primaryMuscleGroup = selectedMuscleGroups.first.flatMap { stringToMuscleGroup($0) }
                            let secondaryMuscleGroups = Array(selectedMuscleGroups.dropFirst()).compactMap { stringToMuscleGroup($0) }
                            
                            selectedPrimaryMuscle = primaryMuscleGroup
                            selectedSecondaryMuscles = secondaryMuscleGroups
                            selectedExercise = exercise
                        }
                    )
                }
            } else {
                // Multiple muscles selected - show grouped sections
                ForEach(Array(selectedMuscleGroups), id: \.self) { muscleGroup in
                    if let muscleData = workoutLibrary[muscleGroup] {
                        // Combine all workouts from all sections for this muscle
                        let allWorkouts = muscleData.sections.flatMap { $0.workouts }
                        let sectionTitle = muscleGroup.capitalized + " Workouts"
                        
                        WorkoutSectionView(
                            title: sectionTitle,
                            workouts: allWorkouts,
                            onExerciseTap: { workout in
                                let exercise = Exercise(
                                    name: workout.name,
                                    sets: extractSets(from: workout.sets),
                                    reps: extractReps(from: workout.sets),
                                    restSeconds: 60,
                                    instructions: "Perform \(workout.name) with proper form."
                                )
                                
                                // Convert selected muscle groups to MuscleGroup enum
                                let primaryMuscleGroup = selectedMuscleGroups.first.flatMap { stringToMuscleGroup($0) }
                                let secondaryMuscleGroups = Array(selectedMuscleGroups.dropFirst()).compactMap { stringToMuscleGroup($0) }
                                
                                selectedExercise = exercise
                                selectedPrimaryMuscle = primaryMuscleGroup
                                selectedSecondaryMuscles = secondaryMuscleGroups
                            }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Simple Mode
    
    private var simpleModeView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 2-Column Grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                SimpleModeCard(
                    title: "Arms",
                    icon: "dumbbell.fill",
                    iconColor: Color(hex: "FF3B30"),
                    isSelected: selectedSimpleBodyPart == "arms"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "arms" ? nil : "arms"
                }
                
                SimpleModeCard(
                    title: "Chest",
                    icon: "heart.fill",
                    iconColor: Color(hex: "FF9500"),
                    isSelected: selectedSimpleBodyPart == "chest"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "chest" ? nil : "chest"
                }
                
                SimpleModeCard(
                    title: "Back",
                    icon: "waveform.path.ecg",
                    iconColor: Color(hex: "0A84FF"),
                    isSelected: selectedSimpleBodyPart == "back"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "back" ? nil : "back"
                }
                
                SimpleModeCard(
                    title: "Shoulders",
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: Color(hex: "AF52DE"),
                    isSelected: selectedSimpleBodyPart == "shoulders"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "shoulders" ? nil : "shoulders"
                }
                
                SimpleModeCard(
                    title: "Legs",
                    icon: "target",
                    iconColor: Color(hex: "34C759"),
                    isSelected: selectedSimpleBodyPart == "legs"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "legs" ? nil : "legs"
                }
                
                SimpleModeCard(
                    title: "Core",
                    icon: "circle",
                    iconColor: Color(hex: "FF3B30"),
                    isSelected: selectedSimpleBodyPart == "abs"
                ) {
                    selectedSimpleBodyPart = selectedSimpleBodyPart == "abs" ? nil : "abs"
                }
            }
            .padding(.horizontal, 24)
            
            // Show workouts if body part selected
            if let bodyPart = selectedSimpleBodyPart, let muscleData = workoutLibrary[bodyPart] {
                // Combine all workouts from all sections into one list
                let allWorkouts = muscleData.sections.flatMap { $0.workouts }
                let sectionTitle = bodyPart.capitalized + " Workouts"
                
                WorkoutSectionView(
                    title: sectionTitle,
                    workouts: allWorkouts,
                    onExerciseTap: { workout in
                        let exercise = Exercise(
                            name: workout.name,
                            sets: extractSets(from: workout.sets),
                            reps: extractReps(from: workout.sets),
                            restSeconds: 60,
                            instructions: "Perform \(workout.name) with proper form."
                        )
                        
                        // Convert selected muscle groups to MuscleGroup enum
                        let primaryMuscleGroup = stringToMuscleGroup(bodyPart)
                        let secondaryMuscleGroups: [MuscleGroup] = []
                        
                        selectedPrimaryMuscle = primaryMuscleGroup
                        selectedSecondaryMuscles = secondaryMuscleGroups
                        selectedExercise = exercise
                    }
                )
            }
        }
    }
    
    // MARK: - AI Mode
    
    private var aiModeView: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Duration Selector
            SelectorSection(
                icon: "clock.fill",
                title: "Duration",
                options: ["15m", "20m", "30m", "45m"],
                selected: $selectedDuration
            )
            
            // Intensity Selector
            SelectorSection(
                icon: "bolt.fill",
                title: "Intensity",
                options: ["Light", "Medium", "Hard"],
                selected: $selectedIntensity
            )
            
            // Equipment Selector
            SelectorSection(
                icon: "dumbbell.fill",
                title: "Equipment",
                options: ["Bodyweight", "Dumbbells", "Machines"],
                selected: $selectedEquipment
            )
            
            // Goal Selector
            SelectorSection(
                icon: "heart.fill",
                title: "Goal",
                options: ["Pump", "Strength", "Fat Burn"],
                selected: $selectedGoal
            )
            
            // Generate Button
            Button(action: {
                HapticFeedback.impact(style: .medium)
                aiWorkoutGenerated = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 18, weight: .semibold))
                    Text("Generate My Workout")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "FF3B30"))
                .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
            // Show generated workout if available
            if aiWorkoutGenerated {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Workout")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                        .padding(.horizontal, 24)
                    
                    // Sample AI-generated workout
                    if let chestData = workoutLibrary["chest"] {
                        // Combine all workouts from all sections into one list
                        let allWorkouts = chestData.sections.flatMap { $0.workouts }
                        
                        WorkoutSectionView(
                            title: "Your Workout",
                            workouts: allWorkouts,
                            onExerciseTap: { workout in
                                let exercise = Exercise(
                                    name: workout.name,
                                    sets: extractSets(from: workout.sets),
                                    reps: extractReps(from: workout.sets),
                                    restSeconds: 60,
                                    instructions: "Perform \(workout.name) with proper form."
                                )
                                
                                // Convert selected muscle groups to MuscleGroup enum
                                let primaryMuscleGroup = selectedMuscleGroups.first.flatMap { stringToMuscleGroup($0) }
                                let secondaryMuscleGroups = Array(selectedMuscleGroups.dropFirst()).compactMap { stringToMuscleGroup($0) }
                                
                                selectedExercise = exercise
                                selectedPrimaryMuscle = primaryMuscleGroup
                                selectedSecondaryMuscles = secondaryMuscleGroups
                            }
                        )
                    }
                }
                .padding(.top, 16)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Mode Selector

struct ModeSelector: View {
    @Binding var selectedMode: WorkoutMode
    
    private let containerHeight: CGFloat = 40
    private let padding: CGFloat = 3
    
    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let segmentSpacing: CGFloat = 4
            let segmentWidth = (totalWidth - (padding * 2) - (segmentSpacing * 2)) / 3
            let containerRadius = containerHeight / 2
            let selectedRadius = containerRadius - padding
            
            // Calculate offset for selected segment
            let selectedIndex: CGFloat = {
                switch selectedMode {
                case .bodyMap: return 0
                case .simpleMode: return 1
                case .aiMode: return 2
                }
            }()
            let selectedOffsetX = padding + (selectedIndex * segmentWidth) + (selectedIndex * segmentSpacing)
            
            ZStack {
                // Background container - full pill shape
                RoundedRectangle(cornerRadius: containerRadius)
                    .fill(Color(hex: "F3F4F6"))
                    .frame(height: containerHeight)
                
                // Selected segment - fully rounded pill with padding
                RoundedRectangle(cornerRadius: selectedRadius)
                    .fill(Color(hex: "FF3B30"))
                    .frame(width: segmentWidth, height: containerHeight - (padding * 2))
                    .offset(x: selectedOffsetX - (totalWidth / 2) + (segmentWidth / 2))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedMode)
                
                // Buttons - evenly spaced
                HStack(spacing: segmentSpacing) {
                    ForEach(WorkoutMode.allCases, id: \.self) { mode in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedMode = mode
                            }
                        }) {
                            Text(mode.rawValue)
                                .font(.system(size: 14, weight: selectedMode == mode ? .semibold : .medium))
                                .foregroundColor(selectedMode == mode ? .white : Color(hex: "1C1C1E"))
                                .frame(maxWidth: .infinity)
                                .frame(height: containerHeight)
                        }
                    }
                }
                .padding(.horizontal, padding)
            }
            .frame(height: containerHeight)
        }
        .frame(height: containerHeight)
    }
}

// MARK: - Simple Mode Card

struct SimpleModeCard: View {
    let title: String
    let icon: String
    let iconColor: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 60, height: 60)
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color(hex: "FF3B30") : Color(hex: "E5E5EA"), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Selector Section (AI Mode)

struct SelectorSection: View {
    let icon: String
    let title: String
    let options: [String]
    @Binding var selected: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "FF3B30"))
                
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
            }
            
            HStack(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        withAnimation {
                            selected = option
                        }
                    }) {
                        Text(option)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(selected == option ? .white : Color(hex: "1C1C1E"))
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                selected == option ? Color(hex: "FF3B30") : Color(hex: "F2F2F7")
                            )
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Muscle Region Overlay

struct MuscleRegionOverlay: View {
    let isFront: Bool
    @Binding var selectedMuscleGroup: String
    
    var body: some View {
        GeometryReader { geometry in
            if isFront {
                // Chest tap area
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.15)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.25)
                    .onTapGesture {
                        withAnimation {
                            selectedMuscleGroup = "chest"
                        }
                    }
                
                // Arms tap area
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.4)
                        .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.4)
                        .onTapGesture {
                            withAnimation {
                                selectedMuscleGroup = "arms"
                            }
                        }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.4)
                        .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.4)
                        .onTapGesture {
                            withAnimation {
                                selectedMuscleGroup = "arms"
                            }
                        }
                }
                
                // Abs tap area
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.2)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.55)
                    .onTapGesture {
                        withAnimation {
                            selectedMuscleGroup = "abs"
                        }
                    }
                
                // Legs tap area
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width * 0.3, height: geometry.size.height * 0.35)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.75)
                    .onTapGesture {
                        withAnimation {
                            selectedMuscleGroup = "legs"
                        }
                    }
            } else {
                // Back tap area
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.3)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    .onTapGesture {
                        withAnimation {
                            selectedMuscleGroup = "back"
                        }
                    }
                
                // Shoulders tap area
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.2)
                        .onTapGesture {
                            withAnimation {
                                selectedMuscleGroup = "shoulders"
                            }
                        }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.2)
                        .onTapGesture {
                            withAnimation {
                                selectedMuscleGroup = "shoulders"
                            }
                        }
                }
            }
        }
    }
}

// MARK: - Workout Section View

struct WorkoutSectionView: View {
    let title: String
    let workouts: [WorkoutItem]
    let onExerciseTap: (WorkoutItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "1C1C1E"))
                .padding(.horizontal, 24)
                .padding(.bottom, 4)
            
            // Vertical list instead of horizontal scroll
            VStack(spacing: 12) {
                ForEach(workouts, id: \.name) { workout in
                    WorkoutCardView(workout: workout) {
                        onExerciseTap(workout)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Workout Card View

struct WorkoutCardView: View {
    let workout: WorkoutItem
    let onTap: () -> Void
    
    // Helper functions to extract sets and reps
    private func extractSets(from setsString: String) -> Int {
        if let xIndex = setsString.firstIndex(of: "x") {
            let setsPart = String(setsString[..<xIndex]).trimmingCharacters(in: .whitespaces)
            return Int(setsPart) ?? 3
        }
        return 3
    }
    
    private func extractReps(from setsString: String) -> Int {
        if let xIndex = setsString.firstIndex(of: "x") {
            let repsPart = String(setsString[setsString.index(after: xIndex)...]).trimmingCharacters(in: .whitespaces)
            let cleanedReps = repsPart.replacingOccurrences(of: "s", with: "")
            return Int(cleanedReps) ?? 12
        }
        return 12
    }
    
    // Extract equipment from exercise name
    private var equipment: String {
        let name = workout.name.lowercased()
        if name.contains("barbell") {
            return "Barbell"
        } else if name.contains("dumbbell") || name.contains("db ") {
            return "Dumbbell"
        } else if name.contains("cable") {
            return "Cable Machine"
        } else if name.contains("bodyweight") || name.contains("push-up") || name.contains("pushup") {
            return "Bodyweight"
        } else {
            return "Bodyweight"
        }
    }
    
    // Extract muscle groups from exercise name
    private var muscleGroups: [String] {
        let name = workout.name.lowercased()
        var muscles: [String] = []
        
        if name.contains("chest") || name.contains("bench") || name.contains("press") || name.contains("push") {
            muscles.append("Chest")
        }
        if name.contains("bicep") || name.contains("curl") {
            muscles.append("Biceps")
        }
        if name.contains("tricep") || name.contains("extension") || name.contains("dip") {
            muscles.append("Triceps")
        }
        if name.contains("shoulder") || name.contains("deltoid") {
            muscles.append("Shoulders")
        }
        if name.contains("back") || name.contains("row") || name.contains("pull") {
            muscles.append("Back")
        }
        if name.contains("leg") || name.contains("squat") || name.contains("quad") {
            muscles.append("Legs")
        }
        if name.contains("abs") || name.contains("core") || name.contains("plank") {
            muscles.append("Abs")
        }
        
        return muscles.isEmpty ? [] : muscles
    }
    
    // Determine workout type tag
    private var workoutType: String? {
        let sets = extractSets(from: workout.sets)
        let reps = extractReps(from: workout.sets)
        
        if sets >= 5 && reps <= 6 {
            return "Strength"
        } else if reps >= 12 {
            return "Hypertrophy"
        } else if equipment == "Bodyweight" {
            return "Bodyweight"
        }
        return nil
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Exercise Icon/Placeholder (120px square)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "FF3B30").opacity(0.1),
                                Color(hex: "FF3B30").opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "FF3B30").opacity(0.2), lineWidth: 1)
                    )
                
                // Placeholder icon
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "FF3B30").opacity(0.6))
            }
            .frame(width: 120, height: 120)
            
            // Exercise Details
            VStack(alignment: .leading, spacing: 8) {
                // Exercise Name
                Text(workout.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "1C1C1E"))
                    .lineLimit(2)
                
                // Sets/Reps/Equipment inline
                HStack(spacing: 4) {
                    Text("\(extractSets(from: workout.sets)) sets × \(extractReps(from: workout.sets)) reps")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                    
                    Text("·")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "6E6E73"))
                    
                    Text(equipment)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "6E6E73"))
                }
                
                // Muscle Tags and Workout Type - prevent wrapping
                HStack(spacing: 6) {
                    if let type = workoutType {
                        Text(type)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "6E6E73"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "F2F2F7"))
                            .cornerRadius(8)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    ForEach(muscleGroups.prefix(2), id: \.self) { muscle in
                        Text(muscle)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "FF3B30"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FF3B30").opacity(0.1))
                            .cornerRadius(8)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    if muscleGroups.count > 2 {
                        Text("+\(muscleGroups.count - 2)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "6E6E73"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "F2F2F7"))
                            .cornerRadius(8)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            // Three-dot menu button
            Button(action: {
                HapticFeedback.impact(style: .light)
                // Menu action can be added later
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(90))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            HapticFeedback.impact(style: .light)
            onTap()
        }
    }
}

// Helper functions to extract sets and reps from string like "3x12"
private func extractSets(from setsString: String) -> Int {
    if let xIndex = setsString.firstIndex(of: "x") {
        let setsPart = String(setsString[..<xIndex]).trimmingCharacters(in: .whitespaces)
        return Int(setsPart) ?? 3
    }
    return 3
}

private func extractReps(from setsString: String) -> Int {
    if let xIndex = setsString.firstIndex(of: "x") {
        let repsPart = String(setsString[setsString.index(after: xIndex)...]).trimmingCharacters(in: .whitespaces)
        // Remove "s" if it's a time-based rep (e.g., "60s")
        let cleanedReps = repsPart.replacingOccurrences(of: "s", with: "")
        return Int(cleanedReps) ?? 12
    }
    return 12
}

// Helper function to convert string muscle group to MuscleGroup enum
private func stringToMuscleGroup(_ muscle: String) -> MuscleGroup? {
    switch muscle.lowercased() {
    case "chest":
        return .chest
    case "shoulders", "shoulder":
        return .shoulders
    case "biceps", "bicep":
        return .biceps
    case "forearms", "forearm":
        return .forearms
    case "abs", "abs/core", "core":
        return .abs
    case "obliques", "oblique":
        return .obliques
    default:
        return nil
    }
}

// MARK: - Data Models

struct BodyPartWorkoutSection: Identifiable {
    let id = UUID()
    let title: String
    let workouts: [WorkoutItem]
}

struct WorkoutItem {
    let name: String
    let image: String
    let sets: String
}

struct MuscleGroupData {
    let sections: [BodyPartWorkoutSection]
}

// MARK: - Workout Library

let workoutLibrary: [String: MuscleGroupData] = [
    "chest": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Chest Workouts", workouts: [
            WorkoutItem(name: "Push-ups", image: "pushup.jpg", sets: "3x12"),
            WorkoutItem(name: "Incline DB Press", image: "incline.jpg", sets: "4x8"),
            WorkoutItem(name: "Cable Flyes", image: "cable.jpg", sets: "3x12")
        ]),
        BodyPartWorkoutSection(title: "Strength Chest", workouts: [
            WorkoutItem(name: "Barbell Bench Press", image: "bench.jpg", sets: "5x5"),
            WorkoutItem(name: "Dumbbell Press", image: "dbpress.jpg", sets: "4x6")
        ])
    ]),
    "arms": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Biceps", workouts: [
            WorkoutItem(name: "Barbell Curls", image: "curl.jpg", sets: "3x10"),
            WorkoutItem(name: "Hammer Curls", image: "curl2.jpg", sets: "3x12"),
            WorkoutItem(name: "Cable Curls", image: "cablecurl.jpg", sets: "3x12")
        ]),
        BodyPartWorkoutSection(title: "Triceps", workouts: [
            WorkoutItem(name: "Tricep Dips", image: "dip.jpg", sets: "3x10"),
            WorkoutItem(name: "Overhead Extension", image: "extension.jpg", sets: "3x12"),
            WorkoutItem(name: "Cable Pushdown", image: "pushdown.jpg", sets: "3x12")
        ])
    ]),
    "back": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Back Workouts", workouts: [
            WorkoutItem(name: "Pull-ups", image: "pullup.jpg", sets: "3x8"),
            WorkoutItem(name: "Barbell Rows", image: "row.jpg", sets: "4x8"),
            WorkoutItem(name: "Lat Pulldown", image: "pulldown.jpg", sets: "3x10")
        ]),
        BodyPartWorkoutSection(title: "Upper Back", workouts: [
            WorkoutItem(name: "Cable Rows", image: "cablerow.jpg", sets: "3x12"),
            WorkoutItem(name: "Face Pulls", image: "facepull.jpg", sets: "3x15")
        ])
    ]),
    "legs": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Leg Workouts", workouts: [
            WorkoutItem(name: "Squats", image: "squat.jpg", sets: "4x8"),
            WorkoutItem(name: "Leg Press", image: "legpress.jpg", sets: "3x12"),
            WorkoutItem(name: "Lunges", image: "lunge.jpg", sets: "3x10")
        ]),
        BodyPartWorkoutSection(title: "Hamstrings", workouts: [
            WorkoutItem(name: "Romanian Deadlift", image: "rdl.jpg", sets: "3x8"),
            WorkoutItem(name: "Leg Curls", image: "curl.jpg", sets: "3x12")
        ])
    ]),
    "shoulders": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Shoulder Workouts", workouts: [
            WorkoutItem(name: "Overhead Press", image: "ohp.jpg", sets: "4x6"),
            WorkoutItem(name: "Lateral Raises", image: "lateral.jpg", sets: "3x12"),
            WorkoutItem(name: "Front Raises", image: "front.jpg", sets: "3x12")
        ])
    ]),
    "abs": MuscleGroupData(sections: [
        BodyPartWorkoutSection(title: "Core Workouts", workouts: [
            WorkoutItem(name: "Plank", image: "plank.jpg", sets: "3x60s"),
            WorkoutItem(name: "Crunches", image: "crunch.jpg", sets: "3x15"),
            WorkoutItem(name: "Leg Raises", image: "legraise.jpg", sets: "3x12")
        ]),
        BodyPartWorkoutSection(title: "Advanced Core", workouts: [
            WorkoutItem(name: "Russian Twists", image: "twist.jpg", sets: "3x20"),
            WorkoutItem(name: "Mountain Climbers", image: "climber.jpg", sets: "3x30")
        ])
    ])
]

// MARK: - Time Selector Chip

struct TimeSelectorChip: View {
    @Binding var selectedTime: Int
    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: {
            showSheet = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6E6E73"))
                
                Text("\(selectedTime) min")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "1C1C1E"))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 4)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .fixedSize()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "F2F2F7"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: "E5E5EA"), lineWidth: 1)
            )
        }
    }
}

// MARK: - Gym Selector Chip

struct GymSelectorChip: View {
    @Binding var selectedGymType: GymType
    @Binding var showSheet: Bool
    
    var displayText: String {
        switch selectedGymType {
        case .homeBodyweight:
            return "Home"
        case .homeDumbbells:
            return "Home"
        case .commercialGym:
            return "Commercial"
        case .hotelGym:
            return "Hotel"
        case .custom:
            return "Custom"
        }
    }
    
    var body: some View {
        Button(action: {
            showSheet = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "house")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "6E6E73"))
                
                Text(displayText)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "1C1C1E"))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 4)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(hex: "6E6E73"))
                    .fixedSize()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "F2F2F7"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: "E5E5EA"), lineWidth: 1)
            )
        }
    }
}

// MARK: - Time Selector Sheet

struct TimeSelectorSheet: View {
    @Binding var selectedTime: Int
    @Binding var showCustomTime: Bool
    @Binding var customTimeValue: String
    @Binding var isPresented: Bool
    
    let timeOptions = [10, 15, 20, 25, 30, 45, 60]
    
    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Drag indicator
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color(hex: "C7C7CC"))
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                
                // Header
                HStack {
                    Text("Select Workout Duration")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Time options grid - 2 columns
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(timeOptions, id: \.self) { time in
                            Button(action: {
                                selectedTime = time
                                isPresented = false
                            }) {
                                Text("\(time) min")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(selectedTime == time ? .white : Color(hex: "1C1C1E"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(selectedTime == time ? Color(hex: "FF3B30") : Color(hex: "F2F2F7"))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    
                    // Custom option - full width
                    Button(action: {
                        showCustomTime = true
                    }) {
                        HStack {
                            Text("Custom...")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color(hex: "1C1C1E"))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "C7C7CC"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(hex: "F2F2F7"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
                    
                    if showCustomTime {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Enter custom duration (minutes)")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(hex: "6E6E73"))
                            
                            #if os(iOS)
                            TextField("e.g., 35", text: $customTimeValue)
                                .keyboardType(.numberPad)
                                .font(.system(size: 17))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(hex: "F2F2F7"))
                                .cornerRadius(12)
                            #else
                            TextField("e.g., 35", text: $customTimeValue)
                                .font(.system(size: 17))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(hex: "F2F2F7"))
                                .cornerRadius(12)
                            #endif
                            
                            Button(action: {
                                if let customTime = Int(customTimeValue), customTime > 0 {
                                    selectedTime = customTime
                                    isPresented = false
                                }
                            }) {
                                Text("Apply")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color(hex: "FF3B30"))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(Color.white)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Gym Selector Sheet

struct GymSelectorSheet: View {
    @Binding var selectedGymType: GymType
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Drag indicator
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color(hex: "C7C7CC"))
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                
                // Header
                HStack {
                    Text("Select Gym Type")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "1C1C1E"))
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "1C1C1E"))
                            .frame(width: 32, height: 32)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                
                // Gym options
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(GymType.allCases, id: \.self) { gymType in
                            Button(action: {
                                if gymType == .custom {
                                    // TODO: Navigate to custom gym setup screen
                                    // For now, just select it
                                    selectedGymType = gymType
                                    isPresented = false
                                } else {
                                    selectedGymType = gymType
                                    isPresented = false
                                }
                            }) {
                                HStack {
                                    Text(gymType.rawValue)
                                        .font(.system(size: 17, weight: .medium))
                                        .foregroundColor(selectedGymType == gymType ? .white : Color(hex: "1C1C1E"))
                                    
                                    Spacer()
                                    
                                    if gymType == .custom && selectedGymType != gymType {
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(hex: "C7C7CC"))
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(selectedGymType == gymType ? Color(hex: "FF3B30") : Color(hex: "F2F2F7"))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.white)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    BodyPartRecommendationView()
}



