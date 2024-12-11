import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Iniciar sesión'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Registrarse como usuario'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                );
              },
              child: Text('Restablecimiento de contraseña'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
              child: Text('Acerca de la app'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddContactPage()),
                );
              },
              child: Text('Agregar un contacto'),
            ),
          ],
        ),
      ),
    );
  }
}

//Esta es la clase para que el usuario pueda iniciar sesion
class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock, size: 60, color: Colors.grey),
                ),
                SizedBox(height: 20),
                buildTextField('Cédula'),
                buildTextField('Contraseña', obscureText: true),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpensePage()),
                        );
                      },
                      child: Text('Acceder'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text('Registrarme'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Regresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $labelText';
          }
          return null;
        },
      ),
    );
  }
}

// clase para que se pueda registar el usuario
class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _genderController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

  final DatabaseReference _db = FirebaseDatabase.instance
      .ref()
      .child('users'); // Referencia al nodo "users"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                SizedBox(height: 20),
                buildTextField('Nombre', _nameController),
                buildTextField('Apellido', _lastNameController),
                buildTextField('Cédula', _cedulaController,
                    keyboardType: TextInputType.number), // Campo para la cédula
                buildTextField('Contraseña', _passwordController,
                    obscureText: true),
                buildTextField('Repetir Contraseña', _repeatPasswordController,
                    obscureText: true),
                buildTextField('Email', _emailController,
                    keyboardType: TextInputType.emailAddress),
                buildTextField('Teléfono', _phoneController,
                    keyboardType: TextInputType.phone),
                buildTextField('Género', _genderController),
                buildTextField('País', _countryController),
                buildTextField('Ciudad', _cityController),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text !=
                              _repeatPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Las contraseñas no coinciden')),
                            );
                            return;
                          }

                          // Guardar datos en Firebase Realtime Database
                          await _addUserToFirebase();

                          // Mostrar mensaje de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Usuario registrado con éxito')),
                          );

                          // Limpiar campos después del registro
                          _clearFields();
                        }
                      },
                      child: Text('Registrarse'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Regresar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para construir campos de texto
  Widget buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $labelText';
          }
          return null;
        },
      ),
    );
  }

  // Método para agregar usuario a Firebase
  Future<void> _addUserToFirebase() async {
    final newUser = {
      'name': _nameController.text,
      'lastName': _lastNameController.text,
      'cedula': _cedulaController.text, // Se agrega el campo cédula
      'email': _emailController.text,
      'phone': _phoneController.text,
      'gender': _genderController.text,
      'country': _countryController.text,
      'city': _cityController.text,
    };

    // Guardar en el nodo "users"
    await _db.push().set(newUser);
  }

  // Método para limpiar campos después del registro
  void _clearFields() {
    _nameController.clear();
    _lastNameController.clear();
    _cedulaController.clear(); // Limpiar el campo cédula
    _passwordController.clear();
    _repeatPasswordController.clear();
    _emailController.clear();
    _phoneController.clear();
    _genderController.clear();
    _countryController.clear();
    _cityController.clear();
  }
}

//Clase para recuperar contraseña
class ResetPasswordPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecimiento de Contraseña'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_reset, size: 60, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Text(
                  'Recupera aquí tu contraseña',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                buildTextField('Cédula'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Lógica para recuperar contraseña
                        }
                      },
                      child: Text('Olvidé la contraseña'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Regresar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $labelText';
          }
          return null;
        },
      ),
    );
  }
}

//Clase acerca de la aplicación
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de la App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.info, size: 60, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Desarrollado por...',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              'Luis Angel Vallejo Rodriguez & '
              'John Javier Cerda',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}

//Clase para agregar un contacto
class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final DatabaseReference _db =
      FirebaseDatabase.instance.ref().child('contacts');

  List<Map<String, String>> _contacts = [];
  Map<String, String>? _searchedContact;
  String?
      _selectedContactKey; // Nuevo: para almacenar la clave del contacto seleccionado

  // Método para agregar un contacto y guardarlo en Firebase
  void _addContact() async {
    final contact = {
      'name': _nameController.text,
      'lastname': _lastnameController.text,
      'id': _idController.text,
    };

    // Guardar en Firebase
    await _db.push().set(contact);

    setState(() {
      _contacts.add(contact);
      _clearFields();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contacto agregado exitosamente')),
    );
  }

  // Método para buscar un contacto por cédula en Firebase
  void _searchContact() async {
    final searchId = _searchController.text;
    DatabaseEvent event = await _db.once();

    final snapshot = event.snapshot;
    if (snapshot.exists) {
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      bool found = false;

      data.forEach((key, value) {
        if (value['id'] == searchId) {
          setState(() {
            _searchedContact = {
              'name': value['name'],
              'lastname': value['lastname'],
              'id': value['id'],
            };
            _selectedContactKey = key; // Guardar la clave del contacto
          });
          found = true;
        }
      });

      if (!found) {
        setState(() {
          _searchedContact = null;
          _selectedContactKey = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contacto no encontrado')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay contactos registrados')),
      );
    }
  }

  // Nuevo método para editar un contacto
  void _editContact() async {
    if (_selectedContactKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Primero busque un contacto para editar')),
      );
      return;
    }

    final updatedContact = {
      'name': _nameController.text,
      'lastname': _lastnameController.text,
      'id': _idController.text,
    };

    try {
      await _db.child(_selectedContactKey!).update(updatedContact);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacto actualizado exitosamente')),
      );

      // Limpiar campos y estado
      _clearFields();
      setState(() {
        _searchedContact = null;
        _selectedContactKey = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el contacto: $e')),
      );
    }
  }

  // Nuevo método para eliminar un contacto
  void _deleteContact() async {
    if (_selectedContactKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Primero busque un contacto para eliminar')),
      );
      return;
    }

    try {
      await _db.child(_selectedContactKey!).remove();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contacto eliminado exitosamente')),
      );

      // Limpiar campos y estado
      _clearFields();
      setState(() {
        _searchedContact = null;
        _selectedContactKey = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el contacto: $e')),
      );
    }
  }

  // Método para limpiar los campos de entrada
  void _clearFields() {
    _nameController.clear();
    _lastnameController.clear();
    _idController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Contacto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.contact_page, size: 100, color: Colors.grey),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _lastnameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Cédula'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addContact,
              child: Text('Agregar'),
            ),
            ElevatedButton(
              onPressed: _editContact,
              child: Text('Editar'),
            ),
            ElevatedButton(
              onPressed: _deleteContact,
              child: Text('Eliminar'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Buscar por Cédula'),
            ),
            ElevatedButton(
              onPressed: _searchContact,
              child: Text('Buscar'),
            ),
            if (_searchedContact != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(
                        '${_searchedContact!['name']} ${_searchedContact!['lastname']}'),
                    subtitle: Text('Cédula: ${_searchedContact!['id']}'),
                  ),
                ),
              )
            else
              SizedBox.shrink(),
            // Resto del código anterior...
          ],
        ),
      ),
    );
  }
}

//Después de iniciar sesion
class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref().child('transactions');

  List<Map<String, dynamic>> _transactions = [];

  // Método para agregar transacciones
  void _addTransaction() async {
    final transactionId = _idController.text.trim();
    final transaction = {
      'id': transactionId,
      'amount': _amountController.text,
      'category': _categoryController.text,
      'type': 'Ingreso', // Cambiar a 'Gasto' según sea necesario
    };

    if (transactionId.isEmpty || transaction['amount']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    await _db.child(transactionId).set(transaction);

    setState(() {
      _transactions.add(transaction);
      _clearFields();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transacción agregada con éxito')),
    );
  }

  // Método para editar transacciones
  void _editTransaction() async {
    final transactionId = _idController.text.trim();
    final updatedTransaction = {
      'amount': _amountController.text,
      'category': _categoryController.text,
      'type': 'Ingreso', // Cambiar a 'Gasto' según sea necesario
    };

    if (transactionId.isEmpty || updatedTransaction['amount']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    await _db.child(transactionId).update(updatedTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transacción actualizada con éxito')),
    );
  }

  void _viewTransactions() async {
    try {
      // Obtener una instantánea de todos los registros
      DataSnapshot snapshot = await _db.get();

      // Verificar si hay datos
      if (snapshot.exists) {
        // Convertir los datos a una lista de mapas
        List<Map<String, dynamic>> transactions = [];

        // Iterar sobre los hijos del snapshot
        snapshot.children.forEach((child) {
          transactions.add(Map<String, dynamic>.from(child.value as Map));
        });

        // Mostrar un diálogo con los registros
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registros de Transacciones'),
              content: SingleChildScrollView(
                child: Column(
                  children: transactions.map((transaction) {
                    return ListTile(
                      title: Text('Monto: ${transaction['amount']}'),
                      subtitle: Text(
                          'Categoría: ${transaction['category']} | Tipo: ${transaction['type']}'),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
              ],
            );
          },
        );
      } else {
        // Mostrar un mensaje si no hay registros
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay transacciones registradas')),
        );
      }
    } catch (e) {
      // Manejar cualquier error en la recuperación de datos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al recuperar transacciones: $e')),
      );
    }
  }

  // Método para eliminar registros
  void _deleteTransaction() async {
    final transactionId = _idController.text.trim();

    if (transactionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese el ID de la transacción')),
      );
      return;
    }

    await _db.child(transactionId).remove();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Transacción eliminada con éxito')),
    );
  }

  // Método para limpiar campos
  void _clearFields() {
    _idController.clear();
    _amountController.clear();
    _categoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Gasto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.money, size: 100, color: Colors.grey),
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID Compra'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTransaction,
              child: Text('Añadir Movimiento'),
            ),
            ElevatedButton(
              onPressed: _editTransaction,
              child: Text('Editar Transacciones'),
            ),
            ElevatedButton(
              // Nuevo botón para ver registros
              onPressed: _viewTransactions,
              child: Text('Ver Registros'),
            ),
            ElevatedButton(
              onPressed: _deleteTransaction,
              child: Text('Eliminar Registros'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
