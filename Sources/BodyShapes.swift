//
//  BodyShapes.swift
//  Gym Fit
//
//  Created by Pragyat Agrawal on 11/18/25.
//

import SwiftUI

// MARK: - Muscle Enum
enum MuscleGroup {
    case chest
    case shoulders
    case biceps
    case forearms
    case abs
    case obliques
    // add more later:
    // case back, quads, hamstrings, glutes
}

// MARK: - Chest Shape
// Pure geometry shape - NO fill, NO stroke, NO color, NO styling
// All styling is controlled at the call site via .fill()
// Path converted from SVG chest-overlay.svg
struct ChestShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        // SVG path coordinates (normalized 0-1 range)
        path.move(to: CGPoint(x: 0.07895*width, y: 0.82016*height))
        
        path.addCurve(to: CGPoint(x: 0.0117*width, y: 0.60311*height), 
                     control1: CGPoint(x: 0.06433*width, y: 0.77055*height), 
                     control2: CGPoint(x: 0.04094*width, y: 0.71473*height))
        
        path.addLine(to: CGPoint(x: 0, y: 0.5659*height))
        
        path.addCurve(to: CGPoint(x: 0.0117*width, y: 0.46047*height), 
                     control1: CGPoint(x: 0, y: 0.5659*height), 
                     control2: CGPoint(x: 0.00481*width, y: 0.5005*height))
        
        path.addCurve(to: CGPoint(x: 0.04971*width, y: 0.30543*height), 
                     control1: CGPoint(x: 0.01858*width, y: 0.42044*height), 
                     control2: CGPoint(x: 0.04971*width, y: 0.30543*height))
        
        path.addCurve(to: CGPoint(x: 0.14912*width, y: 0.02637*height), 
                     control1: CGPoint(x: 0.04971*width, y: 0.30543*height), 
                     control2: CGPoint(x: 0.11905*width, y: 0.08218*height))
        
        path.addCurve(to: CGPoint(x: 0.31871*width, y: 0.02637*height), 
                     control1: CGPoint(x: 0.1792*width, y: -0.02945*height), 
                     control2: CGPoint(x: 0.29053*width, y: 0.01965*height))
        
        path.addCurve(to: CGPoint(x: 0.43275*width, y: 0.08218*height), 
                     control1: CGPoint(x: 0.31871*width, y: 0.02637*height), 
                     control2: CGPoint(x: 0.37134*width, y: 0.02637*height))
        
        path.addCurve(to: CGPoint(x: 0.59649*width, y: 0.04992*height), 
                     control1: CGPoint(x: 0.49415*width, y: 0.13799*height), 
                     control2: CGPoint(x: 0.57602*width, y: 0.04992*height))
        
        path.addCurve(to: CGPoint(x: 0.71053*width, y: 0.01951*height), 
                     control1: CGPoint(x: 0.60788*width, y: 0.04992*height), 
                     control2: CGPoint(x: 0.66667*width, y: 0.02637*height))
        
        path.addCurve(to: CGPoint(x: 0.78947*width, y: 0.00156*height), 
                     control1: CGPoint(x: 0.75438*width, y: 0.01266*height), 
                     control2: CGPoint(x: 0.76395*width, y: 0.00148*height))
        
        path.addCurve(to: CGPoint(x: 0.85673*width, y: 0.01951*height), 
                     control1: CGPoint(x: 0.84703*width, y: 0.00176*height), 
                     control2: CGPoint(x: 0.85673*width, y: 0.01951*height))
        
        path.addLine(to: CGPoint(x: 0.90059*width, y: 0.15757*height))
        path.addLine(to: CGPoint(x: 0.96491*width, y: 0.34264*height))
        path.addLine(to: CGPoint(x: width, y: 0.51628*height))
        path.addLine(to: CGPoint(x: 0.99123*width, y: 0.60311*height))
        path.addLine(to: CGPoint(x: 0.92398*width, y: 0.80155*height))
        path.addLine(to: CGPoint(x: 0.88012*width, y: 0.90698*height))
        path.addLine(to: CGPoint(x: 0.82456*width, y: 0.97519*height))
        
        path.addCurve(to: CGPoint(x: 0.77193*width, y: height), 
                     control1: CGPoint(x: 0.82456*width, y: 0.97519*height), 
                     control2: CGPoint(x: 0.80702*width, y: height))
        
        path.addLine(to: CGPoint(x: 0.73392*width, y: height))
        path.addLine(to: CGPoint(x: 0.57602*width, y: 0.90698*height))
        path.addLine(to: CGPoint(x: 0.43275*width, y: 0.90698*height))
        path.addLine(to: CGPoint(x: 0.35672*width, y: 0.95039*height))
        path.addLine(to: CGPoint(x: 0.25731*width, y: height))
        
        path.addCurve(to: CGPoint(x: 0.17836*width, y: 0.97519*height), 
                     control1: CGPoint(x: 0.25731*width, y: height), 
                     control2: CGPoint(x: 0.19684*width, y: 0.99444*height))
        
        path.addCurve(to: CGPoint(x: 0.11988*width, y: 0.90698*height), 
                     control1: CGPoint(x: 0.15988*width, y: 0.95595*height), 
                     control2: CGPoint(x: 0.11988*width, y: 0.90698*height))
        
        path.addCurve(to: CGPoint(x: 0.07895*width, y: 0.82016*height), 
                     control1: CGPoint(x: 0.11988*width, y: 0.90698*height), 
                     control2: CGPoint(x: 0.09357*width, y: 0.86977*height))
        
        path.closeSubpath()
        
        return path
    }
}

struct LeftShoulderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.19006*width, y: 0.84634*height))
        path.addCurve(to: CGPoint(x: 0.40058*width, y: 0.7439*height), control1: CGPoint(x: 0.23489*width, y: 0.81789*height), control2: CGPoint(x: 0.30702*width, y: 0.76927*height))
        path.addLine(to: CGPoint(x: 0.40058*width, y: 0.71463*height))
        path.addLine(to: CGPoint(x: 0.4269*width, y: 0.62927*height))
        path.addLine(to: CGPoint(x: 0.50585*width, y: 0.51951*height))
        path.addCurve(to: CGPoint(x: 0.59064*width, y: 0.41463*height), control1: CGPoint(x: 0.50585*width, y: 0.51951*height), control2: CGPoint(x: 0.5731*width, y: 0.43415*height))
        path.addCurve(to: CGPoint(x: 0.68713*width, y: 0.33415*height), control1: CGPoint(x: 0.60819*width, y: 0.39512*height), control2: CGPoint(x: 0.66082*width, y: 0.35122*height))
        path.addCurve(to: CGPoint(x: 0.81287*width, y: 0.28537*height), control1: CGPoint(x: 0.71345*width, y: 0.31707*height), control2: CGPoint(x: 0.81287*width, y: 0.28537*height))
        path.addCurve(to: CGPoint(x: 0.90351*width, y: 0.25366*height), control1: CGPoint(x: 0.81287*width, y: 0.28537*height), control2: CGPoint(x: 0.85599*width, y: 0.28537*height))
        path.addCurve(to: CGPoint(x: 0.96784*width, y: 0.18293*height), control1: CGPoint(x: 0.95102*width, y: 0.22195*height), control2: CGPoint(x: 0.9386*width, y: 0.22927*height))
        path.addCurve(to: CGPoint(x: width, y: 0.09268*height), control1: CGPoint(x: 0.99708*width, y: 0.13659*height), control2: CGPoint(x: width, y: 0.09268*height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 0.96784*width, y: 0.04634*height))
        path.addLine(to: CGPoint(x: 0.8655*width, y: 0.11707*height))
        path.addLine(to: CGPoint(x: 0.71053*width, y: 0.18293*height))
        path.addLine(to: CGPoint(x: 0.59064*width, y: 0.22927*height))
        path.addLine(to: CGPoint(x: 0.47368*width, y: 0.25366*height))
        path.addLine(to: CGPoint(x: 0.30702*width, y: 0.28537*height))
        path.addCurve(to: CGPoint(x: 0.19006*width, y: 0.33415*height), control1: CGPoint(x: 0.30702*width, y: 0.28537*height), control2: CGPoint(x: 0.23977*width, y: 0.30488*height))
        path.addCurve(to: CGPoint(x: 0.06725*width, y: 0.4561*height), control1: CGPoint(x: 0.14035*width, y: 0.36341*height), control2: CGPoint(x: 0.09649*width, y: 0.41463*height))
        path.addCurve(to: CGPoint(x: 0.01462*width, y: 0.58049*height), control1: CGPoint(x: 0.03801*width, y: 0.49756*height), control2: CGPoint(x: 0.01462*width, y: 0.58049*height))
        path.addLine(to: CGPoint(x: 0, y: 0.7439*height))
        path.addLine(to: CGPoint(x: 0, y: 0.84634*height))
        path.addLine(to: CGPoint(x: 0, y: 0.88537*height))
        path.addLine(to: CGPoint(x: 0.03801*width, y: 0.99756*height))
        path.addLine(to: CGPoint(x: 0.06725*width, y: 0.97073*height))
        path.addCurve(to: CGPoint(x: 0.19006*width, y: 0.84634*height), control1: CGPoint(x: 0.06725*width, y: 0.97073*height), control2: CGPoint(x: 0.14522*width, y: 0.8748*height))
        path.closeSubpath()
        return path
    }
}

struct RightShoulderShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.83014*width, y: 0.8848*height))
        path.addCurve(to: CGPoint(x: 0.59891*width, y: 0.74265*height), control1: CGPoint(x: 0.78582*width, y: 0.85621*height), control2: CGPoint(x: 0.6914*width, y: 0.76814*height))
        path.addLine(to: CGPoint(x: 0.59891*width, y: 0.71324*height))
        path.addLine(to: CGPoint(x: 0.5729*width, y: 0.62745*height))
        path.addLine(to: CGPoint(x: 0.50351*width, y: 0.51716*height))
        path.addLine(to: CGPoint(x: 0.41104*width, y: 0.42157*height))
        path.addLine(to: CGPoint(x: 0.33011*width, y: 0.33088*height))
        path.addCurve(to: CGPoint(x: 0.19137*width, y: 0.28186*height), control1: CGPoint(x: 0.33011*width, y: 0.33088*height), control2: CGPoint(x: 0.22118*width, y: 0.28186*height))
        path.addCurve(to: CGPoint(x: 0.09021*width, y: 0.25*height), control1: CGPoint(x: 0.16156*width, y: 0.28186*height), control2: CGPoint(x: 0.1223*width, y: 0.27451*height))
        path.addCurve(to: CGPoint(x: 0.00639*width, y: 0.17892*height), control1: CGPoint(x: 0.05811*width, y: 0.22549*height), control2: CGPoint(x: 0.02075*width, y: 0.19853*height))
        path.addCurve(to: CGPoint(x: 0.00639*width, y: 0.08824*height), control1: CGPoint(x: -0.00798*width, y: 0.15931*height), control2: CGPoint(x: 0.00639*width, y: 0.08824*height))
        path.addLine(to: CGPoint(x: 0.00639*width, y: 0))
        path.addLine(to: CGPoint(x: 0.03818*width, y: 0.04902*height))
        path.addLine(to: CGPoint(x: 0.13934*width, y: 0.11275*height))
        path.addLine(to: CGPoint(x: 0.26213*width, y: 0.16176*height))
        path.addCurve(to: CGPoint(x: 0.41104*width, y: 0.22549*height), control1: CGPoint(x: 0.26213*width, y: 0.16176*height), control2: CGPoint(x: 0.3742*width, y: 0.21078*height))
        path.addCurve(to: CGPoint(x: 0.52665*width, y: 0.25*height), control1: CGPoint(x: 0.44787*width, y: 0.2402*height), control2: CGPoint(x: 0.52665*width, y: 0.25*height))
        path.addCurve(to: CGPoint(x: 0.6914*width, y: 0.28186*height), control1: CGPoint(x: 0.52665*width, y: 0.25*height), control2: CGPoint(x: 0.66156*width, y: 0.26961*height))
        path.addCurve(to: CGPoint(x: 0.80702*width, y: 0.33088*height), control1: CGPoint(x: 0.72125*width, y: 0.29412*height), control2: CGPoint(x: 0.76857*width, y: 0.31373*height))
        path.addCurve(to: CGPoint(x: 0.92841*width, y: 0.47059*height), control1: CGPoint(x: 0.84547*width, y: 0.34804*height), control2: CGPoint(x: 0.91366*width, y: 0.45098*height))
        path.addCurve(to: CGPoint(x: 0.98044*width, y: 0.62745*height), control1: CGPoint(x: 0.94317*width, y: 0.4902*height), control2: CGPoint(x: 0.98044*width, y: 0.62745*height))
        path.addLine(to: CGPoint(x: 0.98044*width, y: 0.74265*height))
        path.addLine(to: CGPoint(x: 0.98044*width, y: 0.84559*height))
        path.addCurve(to: CGPoint(x: 0.99489*width, y: 0.8848*height), control1: CGPoint(x: 0.98044*width, y: 0.875*height), control2: CGPoint(x: 0.99489*width, y: 0.8848*height))
        path.addLine(to: CGPoint(x: 0.95732*width, y: 0.99755*height))
        path.addLine(to: CGPoint(x: 0.92841*width, y: 0.97059*height))
        path.addLine(to: CGPoint(x: 0.83014*width, y: 0.8848*height))
        path.closeSubpath()
        return path
    }
}

struct AbsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.06211*width, y: 0.06098*height))
        path.addCurve(to: CGPoint(x: 0.34472*width, y: 0.00494*height), control1: CGPoint(x: 0.17244*width, y: 0.03961*height), control2: CGPoint(x: 0.18012*width, y: 0.01996*height))
        path.addCurve(to: CGPoint(x: 0.65217*width, y: 0.00494*height), control1: CGPoint(x: 0.45022*width, y: -0.00468*height), control2: CGPoint(x: 0.65508*width, y: 0.00224*height))
        path.addCurve(to: CGPoint(x: 0.93478*width, y: 0.06098*height), control1: CGPoint(x: 0.64927*width, y: 0.00765*height), control2: CGPoint(x: 0.77329*width, y: 0.02003*height))
        path.addCurve(to: CGPoint(x: 0.98137*width, y: 0.09331*height), control1: CGPoint(x: 0.96578*width, y: 0.07572*height), control2: CGPoint(x: 0.96953*width, y: 0.06421*height))
        path.addCurve(to: CGPoint(x: 0.99379*width, y: 0.14934*height), control1: CGPoint(x: 0.9932*width, y: 0.1224*height), control2: CGPoint(x: 0.99868*width, y: 0.16122*height))
        path.addCurve(to: CGPoint(x: 0.98137*width, y: 0.28296*height), control1: CGPoint(x: 0.99258*width, y: 0.21669*height), control2: CGPoint(x: 1.0015*width, y: 0.24847*height))
        path.addCurve(to: CGPoint(x: 0.93478*width, y: 0.50063*height), control1: CGPoint(x: 0.98035*width, y: 0.37899*height), control2: CGPoint(x: 0.96114*width, y: 0.42665*height))
        path.addCurve(to: CGPoint(x: 0.90683*width, y: 0.72046*height), control1: CGPoint(x: 0.93993*width, y: 0.58543*height), control2: CGPoint(x: 0.93273*width, y: 0.63343*height))
        path.addCurve(to: CGPoint(x: 0.85714*width, y: 0.99848*height), control1: CGPoint(x: 0.91278*width, y: 0.83378*height), control2: CGPoint(x: 0.89786*width, y: 0.89834*height))
        path.addLine(to: CGPoint(x: 0.14286*width, y: 0.99848*height))
        path.addCurve(to: CGPoint(x: 0.09317*width, y: 0.72046*height), control1: CGPoint(x: 0.10369*width, y: 0.89277*height), control2: CGPoint(x: 0.09391*width, y: 0.8347*height))
        path.addCurve(to: CGPoint(x: 0.06195*width, y: 0.5007*height), control1: CGPoint(x: 0.05894*width, y: 0.63197*height), control2: CGPoint(x: 0.06115*width, y: 0.51366*height))
        path.addCurve(to: CGPoint(x: 0.03106*width, y: 0.28296*height), control1: CGPoint(x: 0.05139*width, y: 0.50406*height), control2: CGPoint(x: 0.01038*width, y: 0.3733*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.16874*height), control1: CGPoint(x: 0.00385*width, y: 0.23327*height), control2: CGPoint(x: 0.00211*width, y: 0.21989*height))
        path.addCurve(to: CGPoint(x: 0.01863*width, y: 0.08621*height), control1: CGPoint(x: 0, y: 0.16874*height), control2: CGPoint(x: 0.00311*width, y: 0.10129*height))
        path.addCurve(to: CGPoint(x: 0.06211*width, y: 0.06098*height), control1: CGPoint(x: 0.03416*width, y: 0.07112*height), control2: CGPoint(x: 0.06211*width, y: 0.06098*height))
        path.closeSubpath()
        return path
    }
}

struct LeftObliqueShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.50944*width, y: 0.99793*height))
        path.addLine(to: CGPoint(x: 0.99645*width, y: 0.99793*height))
        path.addCurve(to: CGPoint(x: 0.88606*width, y: 0.72107*height), control1: CGPoint(x: 0.92944*width, y: 0.89462*height), control2: CGPoint(x: 0.86477*width, y: 0.83565*height))
        path.addCurve(to: CGPoint(x: 0.82113*width, y: 0.52479*height), control1: CGPoint(x: 0.81803*width, y: 0.6388*height), control2: CGPoint(x: 0.81761*width, y: 0.59764*height))
        path.addCurve(to: CGPoint(x: 0.76918*width, y: 0.30372*height), control1: CGPoint(x: 0.76918*width, y: 0.44421*height), control2: CGPoint(x: 0.76918*width, y: 0.40289*height))
        path.addCurve(to: CGPoint(x: 0.76918*width, y: 0.11157*height), control1: CGPoint(x: 0.63992*width, y: 0.21792*height), control2: CGPoint(x: 0.68576*width, y: 0.16522*height))
        path.addCurve(to: CGPoint(x: 0.03541*width, y: 0), control1: CGPoint(x: 0.42578*width, y: 0.10028*height), control2: CGPoint(x: 0.27012*width, y: 0.07301*height))
        path.addCurve(to: CGPoint(x: 0.03541*width, y: 0.08884*height), control1: CGPoint(x: 0.0333*width, y: 0.03489*height), control2: CGPoint(x: 0.03998*width, y: 0.05438*height))
        path.addCurve(to: CGPoint(x: 0.03541*width, y: 0.2376*height), control1: CGPoint(x: -0.00921*width, y: 0.14326*height), control2: CGPoint(x: -0.01433*width, y: 0.1754*height))
        path.addCurve(to: CGPoint(x: 0.23671*width, y: 0.52479*height), control1: CGPoint(x: 0.09856*width, y: 0.39998*height), control2: CGPoint(x: 0.14019*width, y: 0.47082*height))
        path.addCurve(to: CGPoint(x: 0.19126*width, y: 0.75207*height), control1: CGPoint(x: 0.19317*width, y: 0.62895*height), control2: CGPoint(x: 0.16311*width, y: 0.66925*height))
        path.addCurve(to: CGPoint(x: 0.19126*width, y: 0.8781*height), control1: CGPoint(x: 0.13898*width, y: 0.80129*height), control2: CGPoint(x: 0.14652*width, y: 0.82888*height))
        path.addCurve(to: CGPoint(x: 0.50944*width, y: 0.99793*height), control1: CGPoint(x: 0.39355*width, y: 0.95573*height), control2: CGPoint(x: 0.47218*width, y: 0.98549*height))
        path.closeSubpath()
        return path
    }
}

struct RightObliqueShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.46296*width, y: 0.99793*height))
        path.addLine(to: CGPoint(x: 0, y: 0.99793*height))
        path.addCurve(to: CGPoint(x: 0.10494*width, y: 0.72107*height), control1: CGPoint(x: 0.0637*width, y: 0.89462*height), control2: CGPoint(x: 0.12518*width, y: 0.83565*height))
        path.addCurve(to: CGPoint(x: 0.16667*width, y: 0.52479*height), control1: CGPoint(x: 0.16961*width, y: 0.6388*height), control2: CGPoint(x: 0.17001*width, y: 0.59764*height))
        path.addCurve(to: CGPoint(x: 0.21605*width, y: 0.30372*height), control1: CGPoint(x: 0.21605*width, y: 0.44421*height), control2: CGPoint(x: 0.21605*width, y: 0.40289*height))
        path.addLine(to: CGPoint(x: 0.21605*width, y: 0.30372*height))
        path.addCurve(to: CGPoint(x: 0.21605*width, y: 0.11157*height), control1: CGPoint(x: 0.33892*width, y: 0.21792*height), control2: CGPoint(x: 0.29535*width, y: 0.16522*height))
        path.addCurve(to: CGPoint(x: 0.91358*width, y: 0), control1: CGPoint(x: 0.54249*width, y: 0.10028*height), control2: CGPoint(x: 0.69046*width, y: 0.07301*height))
        path.addCurve(to: CGPoint(x: 0.96296*width, y: 0.11157*height), control1: CGPoint(x: 0.91559*width, y: 0.03489*height), control2: CGPoint(x: 0.95862*width, y: 0.07711*height))
        path.addCurve(to: CGPoint(x: 0.96296*width, y: 0.24587*height), control1: CGPoint(x: 1.00538*width, y: 0.16598*height), control2: CGPoint(x: 1.01025*width, y: 0.18367*height))
        path.addCurve(to: CGPoint(x: 0.76543*width, y: 0.52479*height), control1: CGPoint(x: 0.90293*width, y: 0.40825*height), control2: CGPoint(x: 0.80864*width, y: 0.46901*height))
        path.addCurve(to: CGPoint(x: 0.81481*width, y: 0.7562*height), control1: CGPoint(x: 0.80682*width, y: 0.62895*height), control2: CGPoint(x: 0.84157*width, y: 0.67338*height))
        path.addCurve(to: CGPoint(x: 0.76543*width, y: 0.8905*height), control1: CGPoint(x: 0.86451*width, y: 0.80542*height), control2: CGPoint(x: 0.80796*width, y: 0.84128*height))
        path.addCurve(to: CGPoint(x: 0.46296*width, y: 0.99793*height), control1: CGPoint(x: 0.57312*width, y: 0.96813*height), control2: CGPoint(x: 0.49838*width, y: 0.98549*height))
        path.closeSubpath()
        return path
    }
}

struct LeftBicepShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.03132*width, y: 0.83111*height))
        path.addCurve(to: CGPoint(x: 0.03132*width, y: 0.5571*height), control1: CGPoint(x: -0.00528*width, y: 0.76241*height), control2: CGPoint(x: -0.0153*width, y: 0.7129*height))
        path.addCurve(to: CGPoint(x: 0.12902*width, y: 0.27179*height), control1: CGPoint(x: 0.05345*width, y: 0.46619*height), control2: CGPoint(x: 0.04052*width, y: 0.4029*height))
        path.addLine(to: CGPoint(x: 0.4796*width, y: 0.08535*height))
        path.addCurve(to: CGPoint(x: 0.84167*width, y: 0.0006*height), control1: CGPoint(x: 0.56995*width, y: 0.05015*height), control2: CGPoint(x: 0.66004*width, y: 0.03607*height))
        path.addCurve(to: CGPoint(x: 0.9796*width, y: 0.05427*height), control1: CGPoint(x: 0.89744*width, y: -0.00224*height), control2: CGPoint(x: 0.92794*width, y: 0.00334*height))
        path.addLine(to: CGPoint(x: 0.97994*width, y: 0.05625*height))
        path.addCurve(to: CGPoint(x: 0.9796*width, y: 0.29439*height), control1: CGPoint(x: 0.99617*width, y: 0.14879*height), control2: CGPoint(x: 1.00537*width, y: 0.20128*height))
        path.addCurve(to: CGPoint(x: 0.84167*width, y: 0.5571*height), control1: CGPoint(x: 0.94538*width, y: 0.3993*height), control2: CGPoint(x: 0.91378*width, y: 0.45665*height))
        path.addCurve(to: CGPoint(x: 0.51983*width, y: 0.90173*height), control1: CGPoint(x: 0.73723*width, y: 0.72481*height), control2: CGPoint(x: 0.66692*width, y: 0.80055*height))
        path.addCurve(to: CGPoint(x: 0.16925*width, y: 0.99777*height), control1: CGPoint(x: 0.36585*width, y: 0.94198*height), control2: CGPoint(x: 0.28642*width, y: 0.96344*height))
        path.addCurve(to: CGPoint(x: 0.03132*width, y: 0.83111*height), control1: CGPoint(x: 0.09516*width, y: 0.93769*height), control2: CGPoint(x: 0.06396*width, y: 0.90145*height))
        path.closeSubpath()
        return path
    }
}

struct RightBicepShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.96437*width, y: 0.81508*height))
        path.addCurve(to: CGPoint(x: 0.96437*width, y: 0.54564*height), control1: CGPoint(x: 1.00097*width, y: 0.74753*height), control2: CGPoint(x: 1.01099*width, y: 0.69885*height))
        path.addCurve(to: CGPoint(x: 0.82644*width, y: 0.26786*height), control1: CGPoint(x: 0.94224*width, y: 0.45625*height), control2: CGPoint(x: 0.91495*width, y: 0.39679*height))
        path.addLine(to: CGPoint(x: 0.47586*width, y: 0.08453*height))
        path.addCurve(to: CGPoint(x: 0.15403*width, y: 0.00072*height), control1: CGPoint(x: 0.38551*width, y: 0.04992*height), control2: CGPoint(x: 0.33566*width, y: 0.03559*height))
        path.addCurve(to: CGPoint(x: 0.01609*width, y: 0.0512*height), control1: CGPoint(x: 0.09826*width, y: -0.00208*height), control2: CGPoint(x: 0.06775*width, y: 0.00112*height))
        path.addLine(to: CGPoint(x: 0.01575*width, y: 0.05314*height))
        path.addCurve(to: CGPoint(x: 0.01609*width, y: 0.28731*height), control1: CGPoint(x: -0.00048*width, y: 0.14413*height), control2: CGPoint(x: -0.00968*width, y: 0.19575*height))
        path.addCurve(to: CGPoint(x: 0.15403*width, y: 0.54564*height), control1: CGPoint(x: 0.05031*width, y: 0.39047*height), control2: CGPoint(x: 0.08191*width, y: 0.44687*height))
        path.addCurve(to: CGPoint(x: 0.47586*width, y: 0.88453*height), control1: CGPoint(x: 0.25846*width, y: 0.71056*height), control2: CGPoint(x: 0.32878*width, y: 0.78503*height))
        path.addCurve(to: CGPoint(x: 0.82644*width, y: 0.99794*height), control1: CGPoint(x: 0.6092*width, y: 0.94238*height), control2: CGPoint(x: 0.70927*width, y: 0.96417*height))
        path.addCurve(to: CGPoint(x: 0.96437*width, y: 0.81508*height), control1: CGPoint(x: 0.90054*width, y: 0.93886*height), control2: CGPoint(x: 0.93173*width, y: 0.88426*height))
        path.closeSubpath()
        return path
    }
}

struct LeftForearmShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.87698*width, y: 0.44726*height))
        path.addCurve(to: CGPoint(x: width, y: 0.12658*height), control1: CGPoint(x: 0.96054*width, y: 0.32742*height), control2: CGPoint(x: 0.93679*width, y: 0.25512*height))
        path.addCurve(to: CGPoint(x: 0.71032*width, y: 0.21519*height), control1: CGPoint(x: 0.88202*width, y: 0.16536*height), control2: CGPoint(x: 0.81825*width, y: 0.18505*height))
        path.addCurve(to: CGPoint(x: 0.63095*width, y: 0.17722*height), control1: CGPoint(x: 0.68462*width, y: 0.20877*height), control2: CGPoint(x: 0.66805*width, y: 0.20173*height))
        path.addLine(to: CGPoint(x: 0.45238*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.25*width, y: 0.17722*height), control1: CGPoint(x: 0.3679*width, y: 0.06526*height), control2: CGPoint(x: 0.32321*width, y: 0.10379*height))
        path.addCurve(to: CGPoint(x: 0.16667*width, y: 0.33755*height), control1: CGPoint(x: 0.20338*width, y: 0.25531*height), control2: CGPoint(x: 0.18935*width, y: 0.28577*height))
        path.addLine(to: CGPoint(x: 0.10714*width, y: 0.62658*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.94937*height), control1: CGPoint(x: 0.0812*width, y: 0.76577*height), control2: CGPoint(x: 0.05501*width, y: 0.83419*height))
        path.addLine(to: CGPoint(x: 0.36508*width, y: 0.99789*height))
        path.addCurve(to: CGPoint(x: 0.50397*width, y: 0.82068*height), control1: CGPoint(x: 0.40136*width, y: 0.92931*height), control2: CGPoint(x: 0.42865*width, y: 0.89062*height))
        path.addCurve(to: CGPoint(x: 0.75794*width, y: 0.5865*height), control1: CGPoint(x: 0.59178*width, y: 0.7306*height), control2: CGPoint(x: 0.65022*width, y: 0.67899*height))
        path.addCurve(to: CGPoint(x: 0.87698*width, y: 0.44726*height), control1: CGPoint(x: 0.80737*width, y: 0.54009*height), control2: CGPoint(x: 0.83794*width, y: 0.50327*height))
        path.closeSubpath()
        return path
    }
}

struct RightForearmShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.12302*width, y: 0.44538*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.12605*height), control1: CGPoint(x: 0.03946*width, y: 0.32604*height), control2: CGPoint(x: 0.06321*width, y: 0.25405*height))
        path.addCurve(to: CGPoint(x: 0.28968*width, y: 0.21429*height), control1: CGPoint(x: 0.11799*width, y: 0.16466*height), control2: CGPoint(x: 0.18174*width, y: 0.18427*height))
        path.addCurve(to: CGPoint(x: 0.36905*width, y: 0.17647*height), control1: CGPoint(x: 0.31538*width, y: 0.2079*height), control2: CGPoint(x: 0.33195*width, y: 0.20088*height))
        path.addLine(to: CGPoint(x: 0.54762*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.75*width, y: 0.17647*height), control1: CGPoint(x: 0.6321*width, y: 0.06499*height), control2: CGPoint(x: 0.67679*width, y: 0.10335*height))
        path.addCurve(to: CGPoint(x: 0.83333*width, y: 0.33613*height), control1: CGPoint(x: 0.79662*width, y: 0.25424*height), control2: CGPoint(x: 0.81065*width, y: 0.28457*height))
        path.addLine(to: CGPoint(x: 0.89286*width, y: 0.62395*height))
        path.addCurve(to: CGPoint(x: width, y: 0.94538*height), control1: CGPoint(x: 0.9188*width, y: 0.76255*height), control2: CGPoint(x: 0.94498*width, y: 0.83069*height))
        path.addLine(to: CGPoint(x: 0.59921*width, y: 0.9979*height))
        path.addCurve(to: CGPoint(x: 0.4881*width, y: 0.81933*height), control1: CGPoint(x: 0.56292*width, y: 0.92961*height), control2: CGPoint(x: 0.56341*width, y: 0.88897*height))
        path.addCurve(to: CGPoint(x: 0.24206*width, y: 0.58403*height), control1: CGPoint(x: 0.40028*width, y: 0.72963*height), control2: CGPoint(x: 0.34978*width, y: 0.67613*height))
        path.addCurve(to: CGPoint(x: 0.12302*width, y: 0.44538*height), control1: CGPoint(x: 0.19263*width, y: 0.53782*height), control2: CGPoint(x: 0.16207*width, y: 0.50115*height))
        path.closeSubpath()
        return path
    }
}

struct LeftQuadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.42857*width, y: 0.05962*height))
        path.addCurve(to: CGPoint(x: 0.25325*width, y: 0), control1: CGPoint(x: 0.37656*width, y: 0.03941*height), control2: CGPoint(x: 0.3332*width, y: 0.02542*height))
        path.addCurve(to: CGPoint(x: 0.05519*width, y: 0.28975*height), control1: CGPoint(x: 0.14351*width, y: 0.11311*height), control2: CGPoint(x: 0.10284*width, y: 0.17655*height))
        path.addLine(to: CGPoint(x: 0, y: 0.43724*height))
        path.addLine(to: CGPoint(x: 0.01948*width, y: 0.61820*height))
        path.addLine(to: CGPoint(x: 0.05519*width, y: 0.69582*height))
        path.addLine(to: CGPoint(x: 0.14935*width, y: 0.76381*height))
        path.addLine(to: CGPoint(x: 0.14935*width, y: 0.84205*height))
        path.addLine(to: CGPoint(x: 0.14935*width, y: 0.90167*height))
        path.addLine(to: CGPoint(x: 0.22403*width, y: 0.92824*height))
        path.addLine(to: CGPoint(x: 0.29221*width, y: 0.99184*height))
        path.addCurve(to: CGPoint(x: 0.62662*width, y: 0.99184*height), control1: CGPoint(x: 0.34461*width, y: 1.00704*height), control2: CGPoint(x: 0.30812*width, y: 0.99907*height))
        path.addLine(to: CGPoint(x: 0.69792*width, y: 0.93854*height))
        path.addLine(to: CGPoint(x: 0.77484*width, y: 0.8625*height))
        path.addLine(to: CGPoint(x: 0.83894*width, y: 0.73021*height))
        path.addCurve(to: CGPoint(x: width, y: 0.45833*height), control1: CGPoint(x: 0.92841*width, y: 0.62695*height), control2: CGPoint(x: 0.966*width, y: 0.5678*height))
        path.addCurve(to: CGPoint(x: 0.90705*width, y: 0.325*height), control1: CGPoint(x: 0.98272*width, y: 0.40618*height), control2: CGPoint(x: 0.97131*width, y: 0.37694*height))
        path.addCurve(to: CGPoint(x: 0.42857*width, y: 0.05962*height), control1: CGPoint(x: 0.75842*width, y: 0.2255*height), control2: CGPoint(x: 0.66102*width, y: 0.16686*height))
        path.closeSubpath()
        return path
    }
}

struct RightQuadShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.56408*width, y: 0.05962*height))
        path.addCurve(to: CGPoint(x: 0.73715*width, y: 0), control1: CGPoint(x: 0.61109*width, y: 0.03621*height), control2: CGPoint(x: 0.6491*width, y: 0.02317*height))
        path.addCurve(to: CGPoint(x: 0.93266*width, y: 0.28975*height), control1: CGPoint(x: 0.82812*width, y: 0.11358*height), control2: CGPoint(x: 0.87975*width, y: 0.17729*height))
        path.addCurve(to: CGPoint(x: 0.98714*width, y: 0.43724*height), control1: CGPoint(x: 0.95921*width, y: 0.34739*height), control2: CGPoint(x: 0.97208*width, y: 0.37969*height))
        path.addCurve(to: CGPoint(x: 0.96791*width, y: 0.6182*height), control1: CGPoint(x: 1.00189*width, y: 0.51384*height), control2: CGPoint(x: 0.99099*width, y: 0.55168*height))
        path.addCurve(to: CGPoint(x: 0.83971*width, y: 0.7636*height), control1: CGPoint(x: 0.9299*width, y: 0.67794*height), control2: CGPoint(x: 0.90328*width, y: 0.71013*height))
        path.addCurve(to: CGPoint(x: 0.83971*width, y: 0.89854*height), control1: CGPoint(x: 0.8166*width, y: 0.81495*height), control2: CGPoint(x: 0.82152*width, y: 0.84259*height))
        path.addCurve(to: CGPoint(x: 0.76599*width, y: 0.92782*height), control1: CGPoint(x: 0.80852*width, y: 0.90803*height), control2: CGPoint(x: 0.79181*width, y: 0.91672*height))
        path.addCurve(to: CGPoint(x: 0.69032*width, y: 0.99686*height), control1: CGPoint(x: 0.73543*width, y: 0.95163*height), control2: CGPoint(x: 0.71125*width, y: 0.97055*height))
        path.addCurve(to: CGPoint(x: 0.35484*width, y: 0.99477*height), control1: CGPoint(x: 0.52389*width, y: 0.99895*height), control2: CGPoint(x: 0.51852*width, y: height))
        path.addLine(to: CGPoint(x: 0.2871*width, y: 0.94874*height))
        path.addLine(to: CGPoint(x: 0.22115*width, y: 0.86611*height))
        path.addLine(to: CGPoint(x: 0.15705*width, y: 0.73326*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.46025*height), control1: CGPoint(x: 0.07159*width, y: 0.62957*height), control2: CGPoint(x: 0.034*width, y: 0.57018*height))
        path.addCurve(to: CGPoint(x: 0.09295*width, y: 0.32636*height), control1: CGPoint(x: 0.01728*width, y: 0.40787*height), control2: CGPoint(x: 0.02869*width, y: 0.37852*height))
        path.addCurve(to: CGPoint(x: 0.56408*width, y: 0.05962*height), control1: CGPoint(x: 0.24158*width, y: 0.22645*height), control2: CGPoint(x: 0.33898*width, y: 0.16755*height))
        path.closeSubpath()
        return path
    }
}

struct LeftTibialisShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.26563*height))
        path.addCurve(to: CGPoint(x: 0.16228*width, y: 0), control1: CGPoint(x: 0.02424*width, y: 0.17401*height), control2: CGPoint(x: 0.09134*width, y: 0.07618*height))
        path.addLine(to: CGPoint(x: 0.3114*width, y: 0.05682*height))
        path.addLine(to: CGPoint(x: 0.38158*width, y: 0.12784*height))
        path.addLine(to: CGPoint(x: 0.75877*width, y: 0.12784*height))
        path.addLine(to: CGPoint(x: 0.89035*width, y: 0.06818*height))
        path.addCurve(to: CGPoint(x: 0.99561*width, y: 0.34375*height), control1: CGPoint(x: 0.95906*width, y: 0.1776*height), control2: CGPoint(x: 0.97678*width, y: 0.23461*height))
        path.addCurve(to: CGPoint(x: 0.92105*width, y: 0.46307*height), control1: CGPoint(x: 0.97878*width, y: 0.39277*height), control2: CGPoint(x: 0.98002*width, y: 0.42566*height))
        path.addCurve(to: CGPoint(x: 0.82018*width, y: 0.57955*height), control1: CGPoint(x: 0.88337*width, y: 0.50634*height), control2: CGPoint(x: 0.82018*width, y: 0.57955*height))
        path.addCurve(to: CGPoint(x: 0.73684*width, y: 0.85653*height), control1: CGPoint(x: 0.79941*width, y: 0.70624*height), control2: CGPoint(x: 0.70971*width, y: 0.78756*height))
        path.addCurve(to: CGPoint(x: 0.78509*width, y: 0.94744*height), control1: CGPoint(x: 0.77193*width, y: 0.9233*height), control2: CGPoint(x: 0.78509*width, y: 0.94744*height))
        path.addLine(to: CGPoint(x: 0.75*width, y: height))
        path.addLine(to: CGPoint(x: 0.29386*width, y: height))
        path.addCurve(to: CGPoint(x: 0.25877*width, y: 0.85795*height), control1: CGPoint(x: 0.26786*width, y: 0.9711*height), control2: CGPoint(x: 0.23352*width, y: 0.94142*height))
        path.addCurve(to: CGPoint(x: 0.15351*width, y: 0.57244*height), control1: CGPoint(x: 0.2193*width, y: 0.73011*height), control2: CGPoint(x: 0.23113*width, y: 0.68754*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.26563*height), control1: CGPoint(x: 0.06334*width, y: 0.45871*height), control2: CGPoint(x: 0.02997*width, y: 0.3868*height))
        path.closeSubpath()
        return path
    }
}

struct RightTibialisShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.99561*width, y: 0.26563*height))
        path.addCurve(to: CGPoint(x: 0.84649*width, y: 0), control1: CGPoint(x: 0.97138*width, y: 0.17401*height), control2: CGPoint(x: 0.91743*width, y: 0.07618*height))
        path.addLine(to: CGPoint(x: 0.7193*width, y: 0.05256*height))
        path.addLine(to: CGPoint(x: 0.64474*width, y: 0.13352*height))
        path.addLine(to: CGPoint(x: 0.19298*width, y: 0.13352*height))
        path.addLine(to: CGPoint(x: 0.10526*width, y: 0.06818*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.34375*height), control1: CGPoint(x: 0.03655*width, y: 0.1776*height), control2: CGPoint(x: 0.01883*width, y: 0.23461*height))
        path.addCurve(to: CGPoint(x: 0.09649*width, y: 0.45455*height), control1: CGPoint(x: 0.01683*width, y: 0.39277*height), control2: CGPoint(x: 0.07456*width, y: 0.42756*height))
        path.addCurve(to: CGPoint(x: 0.17982*width, y: 0.56818*height), control1: CGPoint(x: 0.11842*width, y: 0.48153*height), control2: CGPoint(x: 0.17982*width, y: 0.56818*height))
        path.addCurve(to: CGPoint(x: 0.25877*width, y: 0.85653*height), control1: CGPoint(x: 0.20059*width, y: 0.69488*height), control2: CGPoint(x: 0.2859*width, y: 0.78756*height))
        path.addCurve(to: CGPoint(x: 0.21053*width, y: 0.94744*height), control1: CGPoint(x: 0.22368*width, y: 0.9233*height), control2: CGPoint(x: 0.21053*width, y: 0.94744*height))
        path.addLine(to: CGPoint(x: 0.24561*width, y: height))
        path.addLine(to: CGPoint(x: 0.74123*width, y: 0.99716*height))
        path.addCurve(to: CGPoint(x: 0.70175*width, y: 0.85511*height), control1: CGPoint(x: 0.76722*width, y: 0.96826*height), control2: CGPoint(x: 0.72701*width, y: 0.93858*height))
        path.addCurve(to: CGPoint(x: 0.83333*width, y: 0.56534*height), control1: CGPoint(x: 0.75766*width, y: 0.73519*height), control2: CGPoint(x: 0.79825*width, y: 0.6733*height))
        path.addCurve(to: CGPoint(x: 0.99561*width, y: 0.26563*height), control1: CGPoint(x: 0.9235*width, y: 0.45161*height), control2: CGPoint(x: 0.96564*width, y: 0.3868*height))
        path.closeSubpath()
        return path
    }
}


