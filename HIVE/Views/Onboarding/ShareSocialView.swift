//
//  ShareSocialView.swift
//  HIVE
//
//  Created by Austin Xu on 2024/10/17.
//

import SwiftUI

struct ShareSocialView: View {
    
    @State private var instagramLink: String = ""
    @State private var isValid: Bool? = nil
    @Binding var showHome: Bool
    
    var body: some View {
        VStack{
            VStack(alignment: .leading) {
                Text("Connect easily")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                Text("Share your Instagram so others can reach out!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                    .padding(.bottom, 50)
                
                TextField("Paste your instagram link here", text: $instagramLink)
                    .onChange(of: instagramLink, { oldValue, newValue in
                        validateLink()
                    })
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(isValid == true ? Color.green : (isValid == false ? Color.red : Color.gray), lineWidth: 2)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if isValid == false {
                    Text("Invalid link! Please enter a valid Instagram profile link.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 250, height: 50)
                .overlay {
                    Text("Done")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                .onTapGesture {
                    // MARK: - Go to Home
                    withAnimation(.linear.delay(0.5)){
                        showHome = true
                    }
                    
                    // if instagram link valid, post the instagram link to backend
                    if isValid == true{
                        // Do action
                    }
                }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip"){
                        //MARK: - Post to backend without instagram link
                        withAnimation(.linear.delay(0.5)){
                            showHome = true
                        }
                        
                    }
                }
            }
        }
        
    }
    
    // Function to validate Instagram profile link
    private func validateLink() {
        // Regular expression for Instagram profile URL
        let profileRegex = #"^https://(www\.)?instagram\.com/([a-zA-Z0-9._]+)(/)?$"#
        
        // Check if the URL matches the regular expression
        if let _ = instagramLink.range(of: profileRegex, options: .regularExpression) {
            isValid = true
        } else {
            isValid = false
        }
    }
}

#Preview {
    ShareSocialView(showHome: .constant(false))
}
