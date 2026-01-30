import SwiftUI

/// Tailwind CSS配色をSwiftUIに移植
@available(iOS 16.0, macOS 10.15, *)
extension Color {
    // MARK: - Indigo (Primary)

    static let indigo50 = Color(red: 238/255, green: 242/255, blue: 255/255)
    static let indigo100 = Color(red: 224/255, green: 231/255, blue: 255/255)
    static let indigo200 = Color(red: 199/255, green: 210/255, blue: 254/255)
    static let indigo300 = Color(red: 165/255, green: 180/255, blue: 252/255)
    static let indigo400 = Color(red: 129/255, green: 140/255, blue: 248/255)
    static let indigo500 = Color(red: 99/255, green: 102/255, blue: 241/255)
    static let indigo600 = Color(red: 79/255, green: 70/255, blue: 229/255)
    static let indigo700 = Color(red: 67/255, green: 56/255, blue: 202/255)
    static let indigo800 = Color(red: 55/255, green: 48/255, blue: 163/255)
    static let indigo900 = Color(red: 49/255, green: 46/255, blue: 129/255)

    // MARK: - Emerald (Secondary/Success)

    static let emerald50 = Color(red: 236/255, green: 253/255, blue: 245/255)
    static let emerald100 = Color(red: 209/255, green: 250/255, blue: 229/255)
    static let emerald200 = Color(red: 167/255, green: 243/255, blue: 208/255)
    static let emerald300 = Color(red: 110/255, green: 231/255, blue: 183/255)
    static let emerald400 = Color(red: 52/255, green: 211/255, blue: 153/255)
    static let emerald500 = Color(red: 16/255, green: 185/255, blue: 129/255)
    static let emerald600 = Color(red: 5/255, green: 150/255, blue: 105/255)
    static let emerald700 = Color(red: 4/255, green: 120/255, blue: 87/255)
    static let emerald800 = Color(red: 6/255, green: 95/255, blue: 70/255)
    static let emerald900 = Color(red: 6/255, green: 78/255, blue: 59/255)

    // MARK: - Slate (Neutral)

    static let slate50 = Color(red: 248/255, green: 250/255, blue: 252/255)
    static let slate100 = Color(red: 241/255, green: 245/255, blue: 249/255)
    static let slate200 = Color(red: 226/255, green: 232/255, blue: 240/255)
    static let slate300 = Color(red: 203/255, green: 213/255, blue: 225/255)
    static let slate400 = Color(red: 148/255, green: 163/255, blue: 184/255)
    static let slate500 = Color(red: 100/255, green: 116/255, blue: 139/255)
    static let slate600 = Color(red: 71/255, green: 85/255, blue: 105/255)
    static let slate700 = Color(red: 51/255, green: 65/255, blue: 85/255)
    static let slate800 = Color(red: 30/255, green: 41/255, blue: 59/255)
    static let slate900 = Color(red: 15/255, green: 23/255, blue: 42/255)

    // MARK: - Amber (Accent/Warning)

    static let amber50 = Color(red: 255/255, green: 251/255, blue: 235/255)
    static let amber100 = Color(red: 254/255, green: 243/255, blue: 199/255)
    static let amber200 = Color(red: 253/255, green: 230/255, blue: 138/255)
    static let amber300 = Color(red: 252/255, green: 211/255, blue: 77/255)
    static let amber400 = Color(red: 251/255, green: 191/255, blue: 36/255)
    static let amber500 = Color(red: 245/255, green: 158/255, blue: 11/255)
    static let amber600 = Color(red: 217/255, green: 119/255, blue: 6/255)
    static let amber700 = Color(red: 180/255, green: 83/255, blue: 9/255)
    static let amber800 = Color(red: 146/255, green: 64/255, blue: 14/255)
    static let amber900 = Color(red: 120/255, green: 53/255, blue: 15/255)
}
