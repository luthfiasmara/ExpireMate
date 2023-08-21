//
//  Detail.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/05/23.
//

import SwiftUI
import CoreData

struct Detail: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @Binding var points: Int
    @State var isSave: Bool = false
//    @Binding var context : NSManagedObjectContext
    var home = Home()
    var body: some View {
        if isSave == true {
            VStack{
                Text("Produk telah habis dikonsumsi")
                    .font(.system(size: 16))
                    .foregroundColor(Color("blue1"))
                    .bold()
                    .multilineTextAlignment(.center)
            }
        } else {
            VStack{
                
                Text("Selamatkan makanan / minuman dengan menghabiskan produk dan dapatkan point")
                    .font(.system(size: 16))
                    .foregroundColor(Color("blue1"))
                    .bold()
                    .multilineTextAlignment(.center)
                Button{
                    self.isSave = true
                    self.points += 20
//                    home.deleteItem(offsets: IndexSet)
//                    updatePoints(context: managedObjContext, isSave: isSave)
                    dismiss()
                }label: {
                    
                    
                    Text("Produk telah habis")
                        .font(.system(size: 15))
                        .frame(width: 180, height:40)
                        .foregroundColor(.white)
                        .background(Color("blue1"))
                        .cornerRadius(6)
                    
                }
                
            }.background(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
    
//    func updatePoints(context: NSManagedObjectContext, isSave: Bool){
//        let item = Item(context: context)
//        item.isSave = isSave
//        DataController().(context: managedObjContext)
//
//    }
}

//struct Detail_Previews: PreviewProvider {
//    static var previews: some View {
//        Detail(points: $points)
//
//    }
//}
