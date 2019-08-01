//
//  HelperViews.swift
//  SwiftUICoreData
//
//  Created by Alfian Losari on 02/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import UIKit

//https://stackoverflow.com/questions/56515871/how-to-open-the-imagepicker-in-swiftui
struct ImagePicker: UIViewControllerRepresentable {
    
    let isShown: Binding<Bool>
    let image: Binding<UIImage?>
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let isShown: Binding<Bool>
        let image: Binding<UIImage?>
        
        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            self.isShown = isShown
            self.image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image.value = uiImage
            isShown.value = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown.value = false
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: isShown, image: image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}



struct MultilineTextView: UIViewRepresentable  {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        let text: Binding<String>
        init(text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.value = textView.text ?? ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}
