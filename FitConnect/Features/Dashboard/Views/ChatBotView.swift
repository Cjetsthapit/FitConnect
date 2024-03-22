//
//  ChatBotView.swift
//  FitConnect
//
//  Created by Nibha Maharjan on 2024-03-21.
//

import SwiftUI
import OpenAI

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    //Add sk- to key
    let openAI = OpenAI(apiToken: "Rb6JDShID9JrAP8tXctDT3BlbkFJqi1fQmdkCIcw821NFmTt")
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let personality = [Chat(role: .user, content: "You must say everything in terms of fitness")]
        openAI.chats(query: .init(model: .gpt3_5Turbo,
                                  messages: personality + self.messages.map({Chat(role: .user, content: $0.content)}))) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                let message = choice.message.content
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message ?? "", isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable{
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

struct ChatBotView: View {
    @StateObject var chatController: ChatController = .init()
        @State var string: String = ""
        var body: some View {
            VStack {
                ScrollView {
                    ForEach(chatController.messages) {
                        message in
                        MessageView(message: message)
                            .padding(5)
                    }
                }
                Divider()
                HStack {
                    TextField("Message...", text: self.$string, axis: .vertical)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    Button {
                        self.chatController.sendNewMessage(content: string)
                        string = ""
                    } label: {
                        Image(systemName: "paperplane")
                    }
                }
                .padding()
            }
        }
}

struct MessageView: View {
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        //.clipShape(Capsule())
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        //.clipShape(Capsule())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ChatBotView()
}
