//
//  HabitVM.swift
//  rooh_test
//
//  Created by Дарья Жданок on 7.04.26.
//

import UIKit

final class HabitVM {
    
    struct Habit {
        let id : UUID
        let title: String
        let imageName: String
        var isCompleted: Bool
    }
}
