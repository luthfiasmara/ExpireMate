//
//  HomeView.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 21/08/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeVM = HomeViewModel()
    var body: some View {
        
        if homeVM.status == .loading{
            VStack{
                Hero(notYetExpired: $homeVM.notYetExpired, hasExpired: $homeVM.hasExpired, points: $homeVM.points)
                
                Spacer().frame(height: 40)
                Spacer()
                Text("Loading...")
                Spacer()
                
            }
        }else if homeVM.status == .error{
            VStack{
                Hero(notYetExpired: $homeVM.notYetExpired, hasExpired: $homeVM.hasExpired, points: $homeVM.points)
                
                Spacer().frame(height: 40)
                Spacer()
                Text("Error! Data not Available")
                Spacer()
                
            }

        }else{
            VStack{
                Hero(notYetExpired: $homeVM.notYetExpired, hasExpired: $homeVM.hasExpired, points: $homeVM.points)
                
                Spacer().frame(height: 40)

                List{
                    ForEach(homeVM.records, id: \.self) { itm in
                        if !itm.isExpired {
                            HStack{
                                VStack(alignment: .leading){
                                    
                                    Text(itm.name )
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    Text("Expired on \(homeVM.dateString(date: itm.endDate  , format: "dd MMMM yyyy - HH:mm"))")
                                        .font(.callout)
                                        .italic()
                                    
                                    
                                    Text(itm.isExpired ? "Past expiry date" : "Not yet expired")
                                        .font(.caption)
                                        .foregroundColor(itm.isExpired ? .red : .green)
                                }
                                .onAppear {
                                    homeVM.notificationAlert(item: itm)
                                }
    //                            .onReceive(timer) { time in
    //                                DataController().checkStatusAndUpdate(context: managedObjContext)
    //                                countTrueData()
    //                                countFalseData()
    //
    //                            }
                                Spacer()
                            }
    //                        .onTapGesture{
    //                            showingDetail.toggle()
    //                        }
                            
                            .listRowBackground(Color.white)
                            
                        }
                    }
    //                .onDelete(perform: homeVM.deleteItem)
                }
                

                Spacer()
            }
            .onAppear {
                homeVM.fetchData()
                homeVM.countFalseData()
                homeVM.countTrueData()
            }

        }
        
                
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeVM: HomeViewModel())
    }
}

struct Hero: View{
    let home = Home()
    @Binding var notYetExpired: Int
    @Binding var hasExpired: Int
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
                    Text(String(notYetExpired))
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
                    Text(String(hasExpired))
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
            .background(Rectangle().fill(.white)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("blue1"), lineWidth: 3)
                )
            )
            .cornerRadius(10)
            .padding(.horizontal, 30)
            .offset(y: 80)
        }
    }
}

