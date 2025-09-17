# Expensiv - An Expense Tracker iOS App
# Overview
The Expensiv - An Expense Tracker iOS App is an easy-to-use application designed to help users manage and track their expenses and incomes. The app provides an intuitive and secure interface for managing financial data and visualizing spending habits, all while maintaining a high level of data protection through Face ID and passcode authentication. The app follows the MVVM (Model-View-ViewModel) architecture, ensuring clean separation of concerns and better maintainability.

# Features
- Track Expenses and Income: Add, view, and categorize your expenses and incomes easily.
- Balance Overview: View total expenses, income, and balance on the Dashboard.
- Pie Chart Visualization: Visualize your expense and income categories with a pie chart for better financial insights.
- Authentication: Secure app access using Face ID or passcode to protect sensitive financial data.
- Customizable Settings: Set app preferences like currency and enable app lock for added security.
- User-friendly Interface: Clean, minimalistic design optimized for iOS devices.

# Tech Stack
- Language: Swift
- Framework: SwiftUI
- Authentication: Local Authentication (Face ID / Passcode)
- Persistence: Core Data and UserDefaults
- Architecture: MVVM (Model-View-ViewModel)

# Screens
The app consists of the following main screens:
- Authentication Screen: Secure login using Face ID or passcode. The authentication process ensures that sensitive financial data is protected and that only authorized users can access the app.
- Dashboard Screen: The Dashboard provides a quick summary of your financial situation, including total expenses, income, and balance. Users can filter expenses by categories, dates, and other criteria for better insights.
- Add/Edit Expense Screen: This screen allows users to add or edit expenses/income. It includes fields for entering the amount, description, and category. The screen is connected to the ViewModel to ensure data is validated and saved to the Model.
- Categories Screen: View your expense and income categories, each represented visually using a pie chart. The ViewModel provides the data for the chart, while the View renders the chart and allows users to interact with it.
- Settings Screen: Customize your app settings, including currency preferences and enabling/disabling the app lock. The settings are saved and persisted using the Model layer, and the ViewModel ensures that changes are reflected in the UI.
- About Screen: Provides details about the app, including version information, developer details, and legal disclaimers. It’s a static screen but can be extended if you wish to add more information in the future.
