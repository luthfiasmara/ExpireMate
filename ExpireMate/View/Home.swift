//
//  Home.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import SwiftUI
import UserNotifications
import CoreData
import AVFoundation
import CloudKit


struct Home: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)])
    var itemList: FetchedResults<Item>
    
//    @StateObject var homeViewModel = HomeViewModel()
    @State var isCameraAuthorized = false
    @State var showingAddView = false
    @State var showingScanner = false
    @State var showingDetail = false
    @State var recognizedText = "Tap button to start scanning"
    @State var a = 0
    @State var b = 0
    @State var points: Int = 0
    @State var permissionGranted = false
    @State var counter = 0
    @State var scannedExpiryDate: Date?
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    
                    Header(a: $a, b: $b, points: $points)
                    
                    Spacer().frame(height: 40)
                    List{
                        ForEach(itemList) { itm in
                            if !itm.isExpired{
                                HStack{
                                    VStack(alignment: .leading){
                                        
                                        Text(itm.name ?? "" )
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text("Expired on \(dateString(date: itm.end_date  ?? Date(), format: "dd MMMM yyyy - HH:mm"))")
                                            .font(.callout)
                                            .italic()
                                        
                                        
                                        Text(itm.isExpired ? "Past expiry date" : "Not yet expired")
                                            .font(.caption)
                                            .foregroundColor(itm.isExpired ? .red : .green)
                                    }
                                    .onAppear {
                                        countTrueData()
                                        countFalseData()
                                        
                                        let center = UNUserNotificationCenter.current()
                                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute ], from: itm.end_date ?? Date())
                                        
                                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                                        
                                        // Create the notification content
                                        let content = UNMutableNotificationContent()
                                        content.title = "Reminder"
                                        content.body = "Your \(itm.name ?? "" ) expired today"
                                        
                                        
                                        // Create the notification request
                                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                        
                                        // Schedule the notification
                                        center.add(request)
                                        
                                        
                                    }
                                    .onReceive(timer) { time in
                                        DataController().checkStatusAndUpdate(context: managedObjContext)
                                        countTrueData()
                                        countFalseData()

                                    }
                                    Spacer()
                                }
                                .onTapGesture{
                                    showingDetail.toggle()
                                }
                                
                                .listRowBackground(Color.white)
                                
                            }
                        }.onDelete(perform: deleteItem)
                    }                        .scrollContentBackground(.hidden)
                    
                        .background(.white)
                        .overlay(Group {
                            
                            if(countFalseData() == 0) {
                                ZStack() {
                                    Color.white.ignoresSafeArea()
                                    VStack{
                                        Text("Belum ada produk")
                                            .font(.system(size: 16))
                                            .foregroundColor(Color("blue1"))
                                            .bold()
                                        Button(action: {
                                            showingAddView.toggle()
                                        }) {
                                            Text("Tambahkan")
                                                .font(.system(size: 15))
                                                .frame(width: 134, height:40)
                                                .foregroundColor(.white)
                                                .background(Color("blue1"))
                                                .cornerRadius(6)
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                            }
                        })
                    
                    
                    Spacer()
                    ZStack{
                        HStack{
                            VStack{
                                Image(systemName: "house")
                                
                                    .resizable()
                                
                                    .scaledToFit()
                                    .foregroundColor(Color("blue1"))
                                    .frame(width: 25)
                                Text("Home")
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            NavigationLink{
                                History()
                            }label: {
                                
                                
                                VStack{
                                    Image(systemName: "clock")
                                    
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color("blue1"))
                                        .frame(width: 25)
                                    Text("History")
                                        .font(.system(size: 12))
                                }
                            }
                            
                        }
                        .padding(.horizontal, 40)
                        if a != 0 {
                            Button(action: {
                                showingAddView.toggle()
                            }) {
                                Circle()
                                    .scaledToFit()
                                    .frame(width: 70)
                                    .foregroundColor(.white )
                                    .overlay( Text("+")
                                        .font(.system(size: 40)))
                                    .foregroundColor(.black)
                                    .shadow(color: Color.gray, radius: 1, x: 0, y: 0.1)
                                    .offset(y: -30)
                                
                            }
                        }
                        
                        
                        
                    }
                    
                    
                }
                .background(.white)
                .foregroundColor(.black)
                //                .toolbar {
                //
                //                    ToolbarItem(placement: .navigationBarTrailing) {
                //                        Button {
                //                            showingAddView.toggle()
                //                        } label: {
                //                            Image(systemName: "plus.circle")
                //                                .resizable()
                //                                .scaledToFit()
                //                                .frame(width: 30)
                //                        }
                //                    }
                //
                //                    ToolbarItem(placement: .navigationBarTrailing) {
                //                        Button {
                //                            showingScanner.toggle()
                //                        } label: {
                //                            Image(systemName: "barcode")
                //                                .resizable()
                //                                .scaledToFit()
                //                                .frame(width: 30)
                //                        }
                //                    }
                //                }
                .sheet(isPresented: $showingAddView) {
                    AddItems()
                }
                .sheet(isPresented: $showingDetail) {
                    Detail(points: $points)
                    
                }
                
            }
        }
        
    }
    func dateString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func deleteItem(offsets: IndexSet) {
        withAnimation {
            offsets.map { itemList[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    
    func countTrueData() -> Int {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: true))
        
        do {
            let result = try managedObjContext.count(for: fetchRequest)
            print(result)
            self.b = result
            return result
        } catch {
            print("Error counting true data: \(error.localizedDescription)")
            return 0
        }
    }
    func countFalseData() -> Int {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isExpired == %@", NSNumber(value: false))
        
        do {
            let result = try managedObjContext.count(for: fetchRequest)
            print("aaaa \(result)")
            self.a = result
            return result
            
            
            
        } catch {
            print("Error counting true data: \(error.localizedDescription)")
            return 0
        }
    }
    
    
}

//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home(vm: ItemListViewModel(container: CKContainer.default()))
//    }
//}


struct Header: View{
    let home = Home()
    @Binding var a: Int
    @Binding var b: Int
    @Binding var points: Int
    
    var body: some View{
        ZStack{
            HStack{
                Text("Hello, **Luthfi Asmara**")
                    .foregroundColor(Color("blue1"))
                    .padding(.leading, 30)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 160)
            .background(Color("yellow1"))
            HStack{
                VStack{
                    Text(String(a))
                        .font(.system(size: 36))
                        .foregroundColor(Color("blue1"))
                        .bold()
                    Text("item will expire")
                        .font(.system(size: 10))
                        .foregroundColor(Color("blue1"))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                }.padding(.leading, 20)
                
                Spacer()
                Divider()
                Spacer()
                VStack{
                    Text(String(b))
                        .font(.system(size: 36))
                        .foregroundColor(Color("blue1"))
                        .bold()
                    Text("item has expire")
                        .font(.system(size: 10))
                        .foregroundColor(Color("blue1"))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                }
                Spacer()
                Divider()
                Spacer()
                HStack{
                    Text(String(points))
                        .font(.system(size: 36))
                        .foregroundColor(Color("blue1"))
                        .bold()
                    Text("pts")
                        .font(.system(size: 15))
                        .foregroundColor(Color("blue1"))
                    
                }.padding(.trailing, 20)
            }
            
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(.white)
            .border(Color("blue1"), width: 1)
            .padding(.horizontal, 30)
            .offset(y: 80)
        }
    }
}
