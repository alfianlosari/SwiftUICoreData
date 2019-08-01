//
//  RecipeFormView.swift
//  SwiftUICoreData
//
//  Created by Alfian Losari on 30/07/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct NoteFormView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var title: String = ""
    @State var content: String = ""
    @State var image: UIImage?
    @State var showImagePicker: Bool = false
    
    @Binding var isPresenting: Bool
    
    var body: some View {
        NavigationView {
            if showImagePicker {
                ImagePicker(isShown: $showImagePicker, image: $image)
            } else {
                Form {
                    Section {
                        TextField("Title", text: $title)
                    }
                    
                    Section(header: Text("Content")) {
                        MultilineTextView(text: $content)
                            .frame(width: nil, height: 150, alignment: .leading)
                            .cornerRadius(8)
                    }
                    
                    Section(header: Text("Image")) {
                        if image != nil {
                            Image(uiImage: image!)
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fit)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,maxHeight: 300, alignment: .center)
                            Button(action: {
                                self.image = nil
                            }) {
                                Text("Delete Image")
                                    .foregroundColor(Color.red)
                            }
                        } else {
                            Button(action: {
                                self.showImagePicker.toggle()
                            }) {
                                Text("Add Image")
                            }
                        }}
                }

                .navigationBarTitle("Add Note")
                .navigationBarItems(trailing:
                    Button(action: {
                        guard !self.title.isEmpty else {
                            return
                        }
                        
                        let note = Note(context: self.context)
                        note.id = UUID()
                        note.title = self.title
                        note.content = self.content
                        note.imageData = self.image?.jpegData(compressionQuality: 30)
                        do {
                            try self.context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                       
                        self.title = ""
                        self.content = ""
                        self.image = nil
                        self.showImagePicker = false
                        self.isPresenting = false
                        self.presentationMode.value.dismiss()
                    }) {
                        Text("Save")
                })
            }
        }
    }
}
