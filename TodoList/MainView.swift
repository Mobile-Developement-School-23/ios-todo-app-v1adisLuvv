//
//  MainView.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-07-22.
//

import SwiftUI

struct MainView: View {
    
    @State private var items: [TodoItem] = [
        TodoItem(text: "buy cheese", priority: .basic, deadline: Date(timeIntervalSince1970: 4235253235), isDone: true),
        TodoItem(text: "buy milk", priority: .important, deadline: Date(timeIntervalSince1970: 4195324535)),
        TodoItem(text: "buy bread", priority: .important, deadline: Date(timeIntervalSince1970: 4432423532), isDone: true),
        TodoItem(text: "buy water", priority: .important, deadline: nil),
        TodoItem(text: "buy salt", priority: .basic, deadline: Date(timeIntervalSince1970: 62120993425)),
        TodoItem(text: "buy eggs", priority: .basic, deadline: nil),
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TasksListView(items: $items)
                
                AddButtonView()
                    .padding(.bottom, 24)
            }
        }
    }
}

struct TasksListView: View {
    
    @Binding var items: [TodoItem]
    
    var body: some View {
        List {
            Section {
                ForEach($items) { item in
                    NavigationLink {
                        VStack {
                            Text("ID: \(item.id)")
                            TextField("Text", text: item.text)
                                .border(.gray)
                        }
                        .padding(.horizontal, 16)
                    } label: {
                        TaskCellView(item: item)
                            .listRowBackground(Color(uiColor: ColorScheme.secondaryBackground))
                            .frame(height: 46)
                    }
                }
            } header: {
                HeaderViewSwiftUI()
                    .padding(.bottom, 8)
            } footer: {
                FooterViewSwiftUI()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 46, alignment: .center)
                    .cornerRadius(8)
                    .padding(.top, -2)
                    .onTapGesture {
                        print("Footer tapped")
                    }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("My tasks")
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: ColorScheme.mainPrimaryBackground))
    }
}

struct TaskCellView: View {
    
    @Binding var item: TodoItem
    
    var body: some View {
        HStack {
            CheckmarkImageView(isDone: $item.isDone)
            
            if item.priority == .important && !item.isDone {
                ExclamationMarkImageView()
            }
            
            VStack(alignment: .leading, spacing: 5){
                if item.isDone {
                    Text(item.text)
                        .font(.body)
                        .strikethrough()
                        .foregroundColor(Color(uiColor: ColorScheme.tertiaryLabel))
                        .lineLimit(3)
                } else {
                    Text(item.text)
                        .font(.body)
                        .foregroundColor(Color(uiColor: ColorScheme.primaryLabel))
                        .lineLimit(3)
                }
                
                if item.deadline != nil && !item.isDone {
                    DeadlineLabelView(deadlineDate: $item.deadline)
                }
            }
        }
    }
}

struct CheckmarkImageView: View {
    
    @Binding var isDone: Bool
    
    var body: some View {
        Image(systemName: isDone ? "checkmark.circle.fill": "circle")
            .renderingMode(.template)
            .resizable()
            .foregroundColor(Color(uiColor: isDone ? ColorScheme.green : ColorScheme.lightGray))
            .fontWeight(isDone ? .bold : .regular)
            .aspectRatio(contentMode: .fit)
            .frame(width: 28, height: 28, alignment: .center)
            .onTapGesture {
                isDone.toggle()
            }
    }
}

struct ExclamationMarkImageView: View {
    
    var body: some View {
        Image(systemName: "exclamationmark.2")
            .renderingMode(.template)
            .resizable()
            .foregroundColor(Color(uiColor: ColorScheme.red))
            .fontWeight(.bold)
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20, alignment: .center)
    }
}

struct DeadlineLabelView: View {
    
    @Binding var deadlineDate: Date?
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "calendar")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color(uiColor: ColorScheme.tertiaryLabel))
                .aspectRatio(contentMode: .fit)
                .frame(width: 15)
            
            Text(stringFromDate(deadlineDate))
                .font(.subheadline)
                .foregroundColor(Color(uiColor: ColorScheme.tertiaryLabel))
        }
    }
    
    private func stringFromDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: date)
    }
}

struct HeaderViewSwiftUI: View {
    var body: some View {
        HStack {
            Text("Completed – \(0)")
                .textCase(nil)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(uiColor: ColorScheme.tertiaryLabel))
            Spacer()
            Button {
                print("Show/hide")
            } label: {
                Text("Show")
                    .textCase(nil)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Color(uiColor: ColorScheme.blue))
            }
        }
    }
}

struct FooterViewSwiftUI: View {
    var body: some View {
        ZStack {
            Color(uiColor: ColorScheme.secondaryBackground)
            HStack {
                Text("New")
                    .font(.system(size: 17))
                    .foregroundColor(Color(uiColor: ColorScheme.tertiaryLabel))
                    .padding(.leading, 56)
                
                Spacer()
            }
        }
    }
}


struct AddButtonView: View {
    var body: some View {
        Button {
            print("add")
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color(uiColor: ColorScheme.blue))
                    .frame(width: 44, height: 44, alignment: .center)
                
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontWeight(.bold)
                    .frame(width: 24, height: 24, alignment: .center)
                    .foregroundColor(Color(uiColor: ColorScheme.white))
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

