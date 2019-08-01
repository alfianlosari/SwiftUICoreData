//
//  ContentView.swift
//  SwiftUICoreData
//
//  Created by Alfian Losari on 30/07/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(entity: Note.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Note.title, ascending: true)])
    private var result: FetchedResults<Note>
    
    @State var isPresenting = false
    var body: some View {
        
        NavigationView {
            List {
                ForEach(result) { note in
                    NoteRow(note: note)
                    
                }.onDelete { (indexSet) in
                    indexSet.forEach { index in
                        let note = self.result[index]
                        self.context.delete(note)
                    }
                    try? self.context.save()
                }
                
            }
            .navigationBarTitle("SwiftUI X CoreData")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isPresenting.toggle()
                }) {
                    Text("Add")
            })
                .sheet(
                    isPresented: $isPresenting,
                    content: {
                        NoteFormView(isPresenting: self.$isPresenting)
                            .environment(\.managedObjectContext, self.context)
                }
            )
        }
    }
}


struct NoteRow: View {
    
    @ObservedObject var note: Note
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if (note.image != nil) {
                GeometryReader { geometry in
                    Image(uiImage: self.note.image!)
                        .resizable(resizingMode: Image.ResizingMode.stretch)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: geometry.size.width)
                        .clipped()
                    
                }
                .frame(maxHeight: 300)
            }
            VStack(alignment: .leading) {
                Text(note.title ?? "")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text(note.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(EdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Rectangle().foregroundColor(Color.black).opacity(0.6).blur(radius: 2.5))
        }
        .background(Color.secondary)
        .cornerRadius(10)
        .shadow(radius: 20)
        .padding(EdgeInsets.init(top: 8, leading: 0, bottom: 8, trailing: 0))
    }
}


