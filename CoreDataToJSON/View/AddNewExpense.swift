//
//  AddNewExpense.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/14.
//

import SwiftUI

struct AddNewExpense: View {
    
    @State private var title: String = ""
    @State private var dateOfPurchase: Date = .init()
    @State private var amountSpent: Double = 0
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    var body: some View {
        NavigationStack {
            List {
                Section("Purchase Item") {
                    TextField("", text: $title)
                }
                
                Section("Date of Purchase") {
                    DatePicker("", selection: $dateOfPurchase, displayedComponents: [.date])
                        .labelsHidden()
                }
                
                Section("Amount Spent") {
                    TextField(value: $amountSpent, formatter: currencyFormatter) {}
                        .labelsHidden()
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add", action: addExpense)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addExpense() {
        do {
            let purchase = Purchase(context: context)
            purchase.id = .init()
            purchase.title = title
            purchase.dateOfPurchase = dateOfPurchase
            purchase.amountSpent = amountSpent
            try context.save()
            
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}

/// Currency Number Formatter
let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.allowsFloats = false
    formatter.numberStyle = .currency
    return formatter
}()
