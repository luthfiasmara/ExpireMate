//
//  Category.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 07/05/23.
//

import SwiftUI

enum ItemCategory: String, Codable, CaseIterable {
    case fruits = "Buah-buahan"
    case vegetables = "Sayuran"
    case dairy = "Produk Susu"
    case meat = "Daging"
    case fish = "Ikan"
    case grains = "Biji-bijian"
    case snacks = "Makanan Ringan"
    case beverages = "Minuman"
    case others = "Lainnya"
    
    var color: Color {
        switch self {
        case .fruits:
            return .orange
        case .vegetables:
            return .green
        case .dairy:
            return .yellow
        case .meat:
            return .red
        case .fish:
            return .blue
        case .grains:
            return .purple
        case .snacks:
            return .pink
        case .beverages:
            return .gray
        case .others:
            return .black
        }
    }
}

struct CategoryPicker: View {
    @Binding var category: ItemCategory
    
    var body: some View {
       
            Picker("Kategori", selection: $category) {
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.automatic)
        }
    }

