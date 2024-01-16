//
//  Home.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/14.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @State private var addExpense = false
    @FetchRequest(entity: Purchase.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Purchase.dateOfPurchase, ascending: false)], animation: .easeInOut(duration: 0.3)) private var purchaseItems: FetchedResults<Purchase>
    
    @Environment(\.managedObjectContext) private var context
    @State private var presentShareSheet = false
    @State private var shareURL: URL = URL(string: "https://apple.com")!

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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Import") {
                            
                        }
                        
                        Button("Export", action: exportCoreData)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: -90))
                    }
                }
                
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
            .sheet(isPresented: $presentShareSheet, content: {
                CustomShareSheet(url: $shareURL)
            })
        }
    }
    
    func exportCoreData() {
        do {
            if let entityName = Purchase.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap { $0 as? Purchase }
                
                let jsonData = try JSONEncoder().encode(items)
                
                if let jsonStr = String(data: jsonData, encoding: .utf8) {
                    // .userDomainMask: 現在の使用ユーザーのホームディレクトリ (~/)
                    if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        // .complete: 日付の完全な形式（年、月、日）
                        let pathURL = url.appending(component: "Export_\(Date().formatted(date: .complete, time: .omitted)).json")
                        
                        try jsonStr.write(to: pathURL, atomically: true, encoding: .utf8)
                        
                        // Saved Successfully
                        shareURL = pathURL
                        presentShareSheet.toggle()
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
