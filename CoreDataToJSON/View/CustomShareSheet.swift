//
//  CustomShareSheet.swift
//  CoreDataToJSON
//
//  Created by paku on 2024/01/16.
//

import SwiftUI

struct CustomShareSheet: UIViewControllerRepresentable {
    
    @Binding var url: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
