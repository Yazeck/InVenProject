//
//  ContentView.swift
//  InVenProj
//
//  Created by Erick Nungaray on 02/04/24.
//

import SwiftUI
//estructuras ventas comunes.
struct SaleRecord: Identifiable, Equatable, Hashable {
    var id = UUID()  // Identificador único para cada registro de venta
    var amount: Double
    var description: String
    
    // Implementación de la función hash(into:)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//estructuras de compras
struct PurchaseRecord: Identifiable, Equatable, Hashable {
    var id = UUID()  // Identificador único para cada registro de compra
    var amount: Double
    var description: String
    
    // Implementación de la función hash(into:)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//estructuras de inventario
struct ItemRecord: Identifiable {
    let id = UUID()
    var description: String
    var isChecked: Bool
}
struct BalanceRecordItem: Identifiable {
    var id = UUID()
    var date: Date
    var salesTotal: Double
    var purchasesTotal: Double
    var balance: Double
}
//estructuras del balance
struct BalanceRecord: Identifiable {
    var id: UUID {
        return UUID()
    }
    var date: Date
    var sales: [SaleRecord]
    var purchases: [PurchaseRecord]
    // Calcula el balance total restando el total de compras del total de ventas
    var balance: Double {
        let totalSales = sales.reduce(0) { $0 + $1.amount }
        let totalPurchases = purchases.reduce(0) { $0 + $1.amount }
        return totalSales - totalPurchases
    }
}
struct MonthlyReportItem {
    var month: String
    var totalBalance: Double
}


// Definición de la vista principal de la aplicación
struct ContentView: View {
    
    // Estado que indica si el usuario ha iniciado sesión o no
    @State private var isLoggedIn = false
    // Estado que almacena el índice de la página seleccionada en el TabView
    @State private var selectedPageIndex = 0
    
    // Definir las listas de ventas y compras aquí
    @State private var sales: [SaleRecord] = []
    @State private var purchases: [PurchaseRecord] = []
    
    var body: some View {
        
       
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
                
       
        // Comprobar si el usuario ha iniciado sesión
        if isLoggedIn {
            // Si el usuario ha iniciado sesión, mostrar el TabView con las páginas principales
            TabView(selection: $selectedPageIndex) {
                // Definición de la página principal (HomePage)
                HomePage(selectedPageIndex: $selectedPageIndex, sales: $sales)
                    .tabItem {
                        Image(systemName: "circle")
                        Text("Ventas")
                    }
                    .tag(0) // Asignar un identificador único a esta página en el TabView
                SecondPage(selectedPageIndex: $selectedPageIndex, purchases: $purchases)
                    .tabItem {
                        Image(systemName: "square")
                        Text("Compras")
                    }
                    .tag(1)
                FourthPage(selectedPageIndex: $selectedPageIndex, sales: $sales, purchases: $purchases)
                    .tabItem {
                        Image(systemName: "triangle")
                        Text("Resumen")
                    }
                    .tag(3)
                ThirdPage(selectedPageIndex: $selectedPageIndex)
                    .tabItem {
                        Image(systemName: "rectangle")
                        Text("Inventario")
                    }
                    .tag(2)
            }
        } else {
            // Si el usuario no ha iniciado sesión, mostrar la página de inicio de sesión (LoginPage)
            LoginPage(isLoggedIn: $isLoggedIn)
        }
    }
}
    }


// Definición de la vista de la página de inicio de sesión
struct LoginPage: View {
    // Estado que indica si el usuario ha iniciado sesión o no
    @Binding var isLoggedIn: Bool
    // Estados que almacenan el nombre de usuario y la contraseña ingresados por el usuario
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
       
            ZStack{
                Color.red
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
        VStack {
            // Campo de texto para ingresar el nombre de usuario
            TextField("Username", text: $username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            // Campo de texto seguro para ingresar la contraseña
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            // Botón para iniciar sesión
            Button(action: {
                // Aquí deberías validar el inicio de sesión, por ejemplo, comparando con credenciales almacenadas.
                // En este caso, simplemente asumiremos que el inicio de sesión es exitoso.
                isLoggedIn = true
            }) {
                Text("Login")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        
        .padding()
                
    }
}
    }
// Definición de la vista de la página principal (HomePage)
struct HomePage: View {
    @Binding var selectedPageIndex: Int
        @Binding var sales: [SaleRecord]
   
    @State private var amountInput: String = ""
    @State private var descriptionInput: String = ""
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private func calculateTotal() -> Double {
        return sales.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
        VStack {
            // Selector para navegar entre las diferentes páginas
            Picker(selection: $selectedPageIndex, label: Text("")) {
                Text("Compras").tag(1)
                Text("Inventario").tag(2)
                Text("Resumen").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
          

            VStack {
                // Título de la página
                Text("Ventas:")
                    .font(.title)
                    .padding()
                
                // Formulario para agregar ventas
                HStack {
                    TextField("Monto", text: $amountInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Descripción", text: $descriptionInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        // Validar que el monto sea un número válido
                        guard let amount = Double(self.amountInput) else {
                            return
                        }
                        // Agregar la venta a la lista de ventas
                        self.sales.append(SaleRecord(amount: amount, description: self.descriptionInput))
                        // Limpiar los campos del formulario
                        self.amountInput = ""
                        self.descriptionInput = ""
                    }) {
                        Text("Agregar")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Lista de ventas
                List {
                    ForEach(sales.indices, id: \.self) { index in
                        HStack {
                            Text("\(numberFormatter.string(for: sales[index].amount) ?? "0.00") - \(sales[index].description)")
                            Spacer()
                            Button(action: {
                                deleteSale(at: index)
                            }) {
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                // Total de ventas
                Text("Total: \(calculateTotal())")
                    .padding()
            }
            .padding()
            
           
        }
        .padding()
            }
            
        }

    private func deleteSale(at index: Int) {
        sales.remove(at: index)
    }
}

// Definición de la vista de la segunda página (SecondPage)
struct SecondPage: View {
    @Binding var selectedPageIndex: Int
    @Binding var purchases: [PurchaseRecord]
    @State private var amountInput: String = ""
    @State private var descriptionInput: String = ""
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private func calculateTotal() -> Double {
        return purchases.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
       
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
        VStack {
            // Selector para navegar entre las diferentes páginas
            Picker(selection: $selectedPageIndex, label: Text("")) {
                Text("Ventas").tag(0)
                Text("Inventario").tag(2)
                Text("Resumen").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
          

            VStack {
                // Título de la página
                Text("Compras:")
                    .font(.title)
                    .padding()
                
                // Formulario para agregar compras
                HStack {
                    TextField("Monto", text: $amountInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                    
                    TextField("Descripción", text: $descriptionInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        // Validar que el monto sea un número válido
                        guard let amount = Double(self.amountInput) else {
                            return
                        }
                        // Agregar la compra a la lista de compras
                        self.purchases.append(PurchaseRecord(amount: amount, description: self.descriptionInput))
                        // Limpiar los campos del formulario
                        self.amountInput = ""
                        self.descriptionInput = ""
                    }) {
                        Text("Agregar")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Lista de compras
                List {
                    ForEach(purchases.indices, id: \.self) { index in
                        HStack {
                            Text("\(numberFormatter.string(for: purchases[index].amount) ?? "0.00") - \(purchases[index].description)")
                            Spacer()
                            Button(action: {
                                deletePurchase(at: index)
                            }) {
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
               
                // Total de compras
                Text("Total: \(calculateTotal())")
                    .padding()
            }
            .padding()
            
           
        }
        .padding()
            }
            
        }

    private func deletePurchase(at index: Int) {
        purchases.remove(at: index)
    }
}

// Definición de la vista de la tercera página (ThirdPage)
struct ThirdPage: View {
    @Binding var selectedPageIndex: Int
    @State private var items: [ItemRecord] = []
    @State private var newItemDescription: String = ""
    
    var body: some View {
        
            ZStack{
                Color.green
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
        VStack {
            // Selector para navegar entre las diferentes páginas
            Picker(selection: $selectedPageIndex, label: Text("")) {
                Text("Ventas").tag(0)
                Text("Compras").tag(1)
                Text("Resumen").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            // Contenido de la tercera página
            Text("Inventario:")
                .font(.title)
                .padding()
            VStack {
                HStack {
                    TextField("Descripción", text: $newItemDescription)
                        .padding()
                    Button(action: addItem) {
                        Text("Agregar")
                    }
                    .padding()
                }
                
                List {
                    ForEach(items.indices, id: \.self) { index in
                        HStack {
                            Text(items[index].description)
                            Spacer()
                            Image(systemName: items[index].isChecked ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    toggleItem(items[index])
                                }
                            Button(action: {
                                deleteItem(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            
            }
            
            Spacer()
        }
            }
            
        }
    
    func addItem() {
        guard !newItemDescription.isEmpty else { return }
        items.append(ItemRecord(description: newItemDescription, isChecked: false))
        newItemDescription = ""
    }
    
    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func deleteItem(at index: Int) {
        items.remove(at: index)
    }
    
    func toggleItem(_ item: ItemRecord) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isChecked.toggle()
        }
    }
}

// En la vista FourthPage:
struct FourthPage: View {
    @Binding var selectedPageIndex: Int
    @Binding var sales: [SaleRecord]
    @Binding var purchases: [PurchaseRecord]
    @State private var balanceRecords: [BalanceRecordItem] = [] // Lista de registros de balance
    @State private var monthlyReports: [MonthlyReportItem] = [] // Lista de reportes mensuales
    
    @State private var saveDate = Date()
    private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    
    var body: some View {
      
            ZStack{
                Color.blue
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(Color.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(Color.white.opacity(0.15))
        VStack {
            // Selector para navegar entre las diferentes páginas
            Picker(selection: $selectedPageIndex, label: Text("")) {
                Text("Ventas").tag(0)
                Text("Compras").tag(1)
                Text("Inventario").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            // Contenido de la cuarta página
            VStack {
                // Botón para guardar las ventas y compras
                Button(action: saveBalance) {
                    Text("Guardar Balance")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // Campo de texto para la fecha de guardado
                DatePicker("Fecha de Guardado", selection: $saveDate, displayedComponents: .date)
                    .padding()
                
                // Tabla para mostrar los registros de balance
                List {
                                    ForEach(balanceRecords) { record in
                                        HStack {
                                            Text("\(record.date)")
                                            Spacer()
                                            Text("Ventas: \(numberFormatter.string(for: record.salesTotal) ?? "0.00")")
                                            Spacer()
                                            Text("Compras: \(numberFormatter.string(for: record.purchasesTotal) ?? "0.00")")
                                            Spacer()
                                            Text("Balance: \(numberFormatter.string(for: record.balance) ?? "0.00")")
                                        }
                                    }
                                }
                
                // Botón para generar el reporte mensual
                Button(action: generateMonthlyReport) {
                    Text("Generar Balance Mensual")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                // Lista de reportes mensuales
                List(monthlyReports, id: \.month) { report in
                                   HStack {
                                       Text("Mes: \(report.month)")
                                       Spacer()
                                       Text("Total Balance: \(numberFormatter.string(for: report.totalBalance) ?? "0.00")")
                                   }
                               }
                
                // Spacer
                Spacer()
            }
            
            Spacer()
        }
        .padding()
            }
            
        }
    
    private func saveBalance() {
        // Calcular totales de ventas y compras
        let totalSales = sales.reduce(0) { $0 + $1.amount }
        let totalPurchases = purchases.reduce(0) { $0 + $1.amount }
        
        // Calcular el balance
        let balance = totalSales - totalPurchases
        
        // Crear un nuevo registro de balance
        let balanceRecord = BalanceRecordItem(date: saveDate, salesTotal: totalSales, purchasesTotal: totalPurchases, balance: balance)
        
        // Agregar el nuevo registro de balance a la lista
        balanceRecords.append(balanceRecord)
        
        // Reiniciar las listas de ventas y compras
        sales = []
        purchases = []
    }
    
    private func generateMonthlyReport() {
        // Agrupar los balances por mes
        let groupedByMonth = Dictionary(grouping: balanceRecords) { record -> String in
            let components = Calendar.current.dateComponents([.year, .month], from: record.date)
            let month = Calendar.current.monthSymbols[components.month! - 1]
            let year = components.year!
            return "\(month) \(year)"
        }
        
        // Calcular el total de balance para cada mes
        let monthlyTotals = groupedByMonth.map { month, records -> MonthlyReportItem in
            let totalBalance = records.reduce(0) { $0 + $1.balance }
            return MonthlyReportItem(month: month, totalBalance: totalBalance)
        }
        
        // Actualizar la lista de reportes mensuales
        monthlyReports = monthlyTotals.sorted { $0.month < $1.month }
    }
}
    
  
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

