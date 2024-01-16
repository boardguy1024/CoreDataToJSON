//
//  Home.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/14.
//

import SwiftUI

struct Home: View {
    
    @State private var addExpense = false
    @FetchRequest(entity: Purchase.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Purchase.dateOfPurchase, ascending: false)], animation: .easeInOut(duration: 0.3)) private var purchaseItems: FetchedResults<Purchase>
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(purchaseItems) { item in
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title ?? "")
                                .fontWeight(.semibold)
                            Text((item.dateOfPurchase ?? .init()).formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Text(currencyFormatter.string(from: NSNumber(value: item.amountSpent)) ?? "")
                            .fontWeight(.bold)
                    }
                    
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $addExpense, content: {
                AddNewExpense()
                     // For iOS 16
                     // [.medium, .large]の場合、中央、トップに固定できる
                    .presentationDetents([.medium, .large]) // sheetのサイズを微調整できる
                    .presentationDragIndicator(.hidden) // つまみの表示・非表示
                    .interactiveDismissDisabled() // おろしてdimissを無効にする
            })
        }
    }
}

#Preview {
    ContentView()
}
