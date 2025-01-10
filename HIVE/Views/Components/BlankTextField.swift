import SwiftUI

struct BlankTextField: View {
  let titleText: String
  @Binding var isValid: Bool
  let isSecuredField: Bool
  @Binding var inputText: String
  @Binding var passwordIsShown: Bool
  @Binding var errorText: TextFieldValidationError?
  @FocusState.Binding var isFocused: Bool
  
  
  var body: some View {
    VStack(alignment:.leading,spacing: 4) {
      Text(titleText)
        .heading6()
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
      if !isValid {
        Text(errorText?.rawValue ?? "")
          .font(CustomFont.createEventBody)
          .foregroundStyle(Color.red.opacity(0.75))
          .lineLimit(nil)
          .multilineTextAlignment(.leading)
      }
      
    }
  }
}


