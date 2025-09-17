//
//  Enums.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//
import SwiftUI

enum ExpensivCDFilterTime: String {
    case all
    case week
    case month
}

enum ExpensivCDSort: String {
    case createdAt
    case updatedAt
    case occuredOn
}

enum AttachmentType: String {
    case camera
    case photoLibrary
}

enum TransactionType: String, CaseIterable {
    case income
    case expense
    
    func getTitle() -> String {
        switch self {
        case .income:
            Constants.incomeText
        case .expense:
            Constants.expenseText
        }
    }
}

enum ExpenseCategoryTagType: String, CaseIterable {
    case transport
    case food
    case housing
    case insurance
    case medical
    case savings
    case personal
    case entertainment
    case utilities
    case others
    
    func getTagTitle() -> String {
        switch self {
        case .transport:
            Constants.transportText
        case .food:
            Constants.foodText
        case .housing:
            Constants.housingText
        case .insurance:
            Constants.insuranceText
        case .medical:
            Constants.medicalText
        case .savings:
            Constants.savingsText
        case .personal:
            Constants.personalText
        case .entertainment:
            Constants.entertainmentText
        case .utilities:
            Constants.utilitiesText
        case .others:
            Constants.othersText
        }
    }
    
    func getTagIcon() -> String {
        switch self {
        case .transport:
            Constants.transTypeTransportIcon
        case .food:
            Constants.transTypeFoodIcon
        case .housing:
            Constants.transTypeHousingIcon
        case .insurance:
            Constants.transTypeInsuranceIcon
        case .medical:
            Constants.transTypeMedicalIcon
        case .savings:
            Constants.transTypeSavingsIcon
        case .personal:
            Constants.transTypePersonalIcon
        case .entertainment:
            Constants.transTypeEntertainmentIcon
        case .utilities:
            Constants.transTypeUtilitiesIcon
        case .others:
            Constants.transTypeOthersIcon
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .transport:
            Color.red
        case .food:
            Color.blue
        case .housing:
            Color.yellow
        case .insurance:
            Color.green
        case .medical:
            Color.purple
        case .savings:
            Color.cyan
        case .personal:
            Color.indigo
        case .entertainment:
            Color.brown
        case .utilities:
            Color.mint
        case .others:
            Color.orange
        }
    }
}

enum TextView_Type {
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case subtitle_1
    case subtitle_2
    case body_1
    case body_2
    case button
    case caption
    case overline
}
