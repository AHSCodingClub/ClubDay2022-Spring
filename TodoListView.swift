//
//  TodoListView.swift
//  SwiftPlaygrounds
//
//  Created by A. Zheng (github.com/aheze) on 1/10/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//


import SwiftUI

struct TodoListItem: Identifiable, Codable {
    var id = UUID()
    var name = ""
    var completed = false
}

struct PieChart: Shape {
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(startAngle, endAngle) }
        set { (startAngle, endAngle) = (newValue.first, newValue.second) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addArc(
            center: center,
            radius: rect.height / 2,
            startAngle: .radians(startAngle),
            endAngle: .radians(endAngle),
            clockwise: false
        )
        return path
    }
}
struct TodoListView: View {
    @State var items = [
        TodoListItem(name: "Learn Swift", completed: true),
        TodoListItem(name: "Learn SwiftUI", completed: false),
        TodoListItem(name: "Bake a cookie", completed: false),
        TodoListItem(name: "Do HW", completed: false)
    ]
    
    @State var editMode = EditMode.inactive
    @State var showingAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Chart") {
                    ZStack {
                        PieChart(startAngle: 0, endAngle: angleCompleted())
                            .fill(Color.green)
                        
                        PieChart(startAngle: angleCompleted(), endAngle: 2 * .pi)
                            .fill(Color.blue)
                    }
                        .frame(height: 150)
                        .overlay(
                            Circle()
                                .fill(Color(uiColor: .systemBackground))
                                .overlay {
                                    VStack {
                                        let itemsCompletedCount = itemsCompletedCount()
                                        if itemsCompletedCount < items.count {
                                            Text("\(itemsCompletedCount) / \(items.count)")
                                                .font(.system(.largeTitle, design: .rounded).bold())
                                        } else {
                                            Image(systemName: "checkmark")
                                                .font(.system(.largeTitle, design: .rounded).bold())
                                        }
                                    }
                                    .foregroundColor(.green)
                                }
                                .padding(24)
                        )
                        .padding()
                }
                
                Section("Actions") {
                    Button {
                        let newItem = TodoListItem()
                        withAnimation(.spring()) {
                            items.insert(newItem, at: 0)
                        }
                    } label: {
                        Text("Add Item")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .opacity(editMode.isEditing ? 0.5 : 1)
                    
                    Button {
                        showingAlert = true
                    } label: {
                        Text("Print Items")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .alert("Here are your current items", isPresented: $showingAlert) {
                        Button("Ok", role: .cancel) { }
                    } message: {
                        let string = items.map { "Name: \($0.name), completed: \($0.completed)" }.joined(separator: "\n")
                        Text(verbatim: string)
                    }
                    .buttonStyle(.plain)
                    .opacity(editMode.isEditing ? 0.5 : 1)
                }
                
                Section("Items") {
                    ForEach($items) { $item in
                        HStack {
                            TextField("Item Name", text: $item.name)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    item.completed.toggle()
                                }
                            } label: {
                                Image(systemName: "checkmark.circle")
                                    .symbolVariant(item.completed ? .fill : .none)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: move)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Todo List")
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
        }
        .navigationViewStyle(.stack)
        .tint(.green)
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation(.spring()) {
            items.remove(atOffsets: offsets)
        }
    }
    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
    
    func itemsCompletedCount() -> Int {
        let itemsCompleted = items.filter { $0.completed }
        return itemsCompleted.count
    }
    
    func angleCompleted() -> CGFloat {
        let percentageCompleted = CGFloat(itemsCompletedCount()) / CGFloat(items.count)
        let angle = (2 * CGFloat.pi) * percentageCompleted
        return angle
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
