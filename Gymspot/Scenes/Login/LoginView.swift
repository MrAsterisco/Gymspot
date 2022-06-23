//
//  LoginView.swift
//  Gymspot
//
//  Created by Alessio Moiso on 08.05.22.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
  @Environment(\.colorScheme) var colorScheme
  
  @StateObject var viewModel = LoginViewModel()
  
  var body: some View {
    VStack {
      Spacer()
      
      VStack(alignment: .leading) {
        Text("Welcome!")
          .font(.largeTitle)
          .bold()
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Text("Sign in with your Apple ID to begin tracking your workouts.")
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      Spacer()
        .frame(height: 20)
      
      switch viewModel.state {
      case .ready:
        SignInWithAppleButton(
          .continue,
          onRequest: viewModel.configureRequest(request:),
          onCompletion: { viewModel.continueWithApple(result: $0) }
        )
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(maxHeight: 60)
      case .loading:
        ProgressView("Loading...")
      case let .error(error):
        Text(error.localizedDescription)
          .foregroundColor(.red)
        Button("Retry", action: { viewModel.state = .ready })
      }
    }
    .padding()
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
