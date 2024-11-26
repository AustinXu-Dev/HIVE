import SwiftUI

struct BlankTextField: View {
  let titleText: String
  let isValid: Bool
  let isSecuredField: Bool
  @Binding var inputText: String
  @Binding var passwordIsShown: Bool
  @Binding var errorText: String
  @FocusState.Binding var isFocused: Bool
  
  
  var body: some View {
    VStack(alignment:.leading,spacing: 4) {
      Text(titleText)
        .font(.caption)
        .bold()
        .foregroundStyle(isFocused ? Color.themeColorPurple : Color.black)
      Group {
        HStack {
          if passwordIsShown {
            TextField("", text: $inputText)
          } else {
            SecureField("",text: $inputText)
          }
          
          
          Image(systemName: passwordIsShown ? "eye" : "eye.slash")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .imageScale(.medium)
            .frame(width: 14, height: 14)
            .fixedSize()
            .padding(.trailing)
            .foregroundStyle(isFocused ? Color.themeColorPurple : Color.black)
            .opacity(isSecuredField ? 1.0 : 0.0)
            .onTapGesture {
              if isSecuredField {
                passwordIsShown.toggle()
              }
            }
        }
      }
      
        .font(CustomFont.createEventBody)
        .background(Color.clear)
        .frame(maxWidth:.infinity)
        .frame(maxHeight:20)
        .cornerRadius(8)
        .textFieldStyle(.plain)
        .focused($isFocused)
      
      Rectangle()
        .frame(maxWidth: .infinity)
        .frame(height:2)
        .foregroundStyle(isFocused ? Color.themeColorPurple : Color.black)
      
      
    }
  }
}

#Preview {
  @FocusState var isFocus_Preview: Bool
  BlankTextField(titleText: "Email", isValid: true, isSecuredField: true, inputText: .constant("example@gmail.com"), passwordIsShown: .constant(true), errorText: .constant(""), isFocused: $isFocus_Preview)
    .padding(.horizontal)
}
