//
//  GetOneUserViewModel.swift
//  HIVE
//
//  Created by Akito Daiki on 21/10/2024.
//

import Foundation

class GetOneUserByIdViewModel: ObservableObject {
    
    @Published var userDetail: UserModel? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading : Bool = false
    @Published var isUnderage: Bool = false
    
    func getOneUserById(id: String) {
        isLoading = true
        errorMessage = nil
        let getOneUser = GetUserById(id: id)
        getOneUser.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userDetailData):
                    self?.isLoading = false
                    self?.userDetail = userDetailData.message
                    print(self?.userDetail?.dateOfBirth ?? "Date not here")
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func getOneUserAndCheckAge(id: String, eventMinAge: Int) {
        isLoading = true
        errorMessage = nil
        let getOneUser = GetUserById(id: id)
        getOneUser.execute(getMethod: "GET", token: nil) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userDetailData):
                    self?.isLoading = false
                    self?.userDetail = userDetailData.message
//                    print(self?.userDetail?.dateOfBirth ?? "Date not here")
                    
                    // Check if the user is underage for the event
                    self?.checkUnderAge(eventMinAge: eventMinAge)
                    
                case .failure(let error):
                    self?.isLoading = false
                    self?.errorMessage = "Failed to get user detail by id: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func checkUnderAge(eventMinAge: Int) {
        guard let userDateOfBirth = parseDate(from: self.userDetail?.dateOfBirth ?? "") else {
            print("Error: Invalid or missing date of birth.")
            isUnderage = false
            return
        }
                
        let userAge = calculateAge(from: userDateOfBirth)

        // Check if the user's age is less than the event's min age
        isUnderage = userAge < eventMinAge
    }

    private func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: dateString)
    }

    private func calculateAge(from date: Date) -> Int {
        let today = Date()
        
        // Ensure that the birthdate is before today
        if date > today {
            return 0 // If birthdate is in the future, return 0 as age
        }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: date, to: today)
        
        // Calculate age in years, considering months and days
        var age = ageComponents.year ?? 0
        
        if let month = ageComponents.month, month < 0 {
            age -= 1 // Adjust age if the user hasn't had their birthday yet this year
        }

        return age
    }


}
