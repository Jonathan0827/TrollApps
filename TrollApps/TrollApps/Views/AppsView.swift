//  SourceView.swift
//  TrollApps
//
//  Created by Cleopatra on 2023-12-01.
//

import SwiftUI
import SDWebImageSwiftUI

struct AppsView: View {
    @EnvironmentObject var repoManager: RepositoryManager
    @EnvironmentObject var alertManager: AlertManager

    @State var showFullVersion: Bool = false

    private let adaptiveCollums = [
        GridItem(.adaptive(minimum: 65))
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredApps.sorted { $0.name < $1.name }) { app in
                    HStack(alignment: .top) {
                        Image(uiImage: app.icon)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.trailing, 8)
                        VStack(alignment: .leading) {
                            Text(app.name)
                            Text(app.id)
                                .font(.caption)
                                .foregroundColor(.gray)
                            CollapsibleText(text: app.version , isExpanded: $showFullVersion, maxLines: 1)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Button("OPEN") {
                            OpenApp(app.id)
                        }
                        .buttonStyle(AppStoreStyle(type: "gray", dissabled: false))
                    }
                    .contextMenu
                    {
                        if(app.id != "com.opa334.TrollStore" && app.id != Bundle.main.bundleIdentifier) {
                            Button(action: {
                                let unistallIPAStatus = UnistallIPA(app.id)
                                
                                if(!unistallIPAStatus.error) {
                                    alertManager.showAlert(
                                        title: Text(LocalizedStringKey("UNINSTALLED_APP \(app.name)")),
                                        body: Text(LocalizedStringKey(""))
                                    )
                                    
                                    repoManager.InstalledApps = GetApps()
                                } else {
                                    alertManager.showAlert(
                                        title: Text(LocalizedStringKey(unistallIPAStatus.message?.title ?? "")),
                                        body: Text(LocalizedStringKey(unistallIPAStatus.message?.body ?? ""))
                                    )
                                }
                            }, label:
                            {
                                Text("UNINSTALL_APP")
                            })
                        } else {
                            Button("UNINSTALL_APP") {} .disabled(true)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 20))
            .environment(\.defaultMinListRowHeight, 50)
            .listStyle(PlainListStyle())
            .navigationTitle("INSTALLED_APPS")
        }
        .navigationViewStyle(.stack)
    }
    
    var filteredApps: [BundledApp] {
        return repoManager.InstalledApps.filter { app in
            app.isTrollStore == true
        }
    }
}
                  
                  
                  //                    .background(
                  //                        NavigationLink("", destination: AppDetailsView(appDetails: app))
                  //                            .opacity(0)
                  //                    )
