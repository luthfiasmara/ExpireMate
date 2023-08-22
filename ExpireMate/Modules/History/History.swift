//
//  History.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 27/04/23.
//

import SwiftUI

struct History: View {

    @StateObject var historyVM = HistoryViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                VStack {
                    List {
                        HStack{
                            Text("History")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        ForEach(historyVM.records) { itm in
                            if itm.isExpired{
                                VStack(alignment: .leading){
                                    Text(itm.name )
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    HStack{
                                        Text("Expired on \(historyVM.dateString(date: itm.endDate , format: "dd MMMM yyyy - HH:mm"))")
                                            .font(.callout)
                                            .italic()
                                        
                                    }
                                    
                                    Text(itm.isExpired ? "Past expiry date" : "Not yet expired")
                                        .font(.caption)
                                        .foregroundColor(itm.isExpired ? .red : .green)
                                    
                                    
                                    
                                }
                                .onAppear {
                                    historyVM.notificationAlert(item: itm)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    

}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
