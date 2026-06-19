# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Full-stack assignment: Spring Boot REST API (`spring_api/`) + Flutter mobile app (`flutter_app/`) managing a `supplier` table (id, name, phone, address) in SQL Server.

**Requirements:**
- Spring Boot: POST endpoint to create a supplier (10 pts)
- Flutter: form to add supplier (5 pts), list to display suppliers (5 pts)

---

## Database Setup (SQL Server)

Run `db.sql` against your SQL Server instance before starting the API:

```sql
-- creates database homework_db and supplier table
-- default credentials in application.properties: sa / 123456
```

---

## Spring API (`spring_api/`)

**Stack:** Spring Boot 4.1.0, JDK 21, Spring Data JPA, SQL Server (`mssql-jdbc`), packaged as WAR.

**Run:**
```bash
cd spring_api
./mvnw spring-boot:run
```

**Build WAR:**
```bash
./mvnw clean package
```

**Test:**
```bash
./mvnw test
```

**API endpoints** (base: `http://localhost:8080`):
- `GET  /api/suppliers` — list all suppliers
- `POST /api/suppliers` — create supplier (JSON body: `name`, `phone`, `address`)

**Key source files:**
- `src/main/java/com/example/demo/model/Supplier.java` — JPA entity
- `src/main/java/com/example/demo/repository/SupplierRepository.java` — Spring Data repo
- `src/main/java/com/example/demo/controller/SupplierController.java` — REST controller with `@CrossOrigin("*")`
- `src/main/resources/application.properties` — datasource URL, credentials, JPA settings

**Database config** (`application.properties`):
```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=homework_db;encrypt=false;trustServerCertificate=true
spring.datasource.username=sa
spring.datasource.password=123456
spring.jpa.hibernate.ddl-auto=update
```

---

## Flutter App (`flutter_app/`)

**Stack:** Flutter SDK ^3.12.2, Dart, `http` package for REST calls.

**Run:**
```bash
cd flutter_app
flutter pub get
flutter run
```

**Key source files:**
- `lib/main.dart` — app entry point, sets `SupplierListScreen` as home
- `lib/models/supplier.dart` — Supplier data class with `fromJson`/`toJson`
- `lib/services/api_service.dart` — HTTP calls to Spring API
- `lib/screens/supplier_list_screen.dart` — displays supplier list, FAB navigates to form
- `lib/screens/supplier_form_screen.dart` — form to create a supplier

**API base URL** (in `lib/services/api_service.dart`):
```dart
static const String baseUrl = 'http://10.0.2.2:8080/api/suppliers';
```
`10.0.2.2` maps to the host machine's `localhost` from an Android emulator. Change to `http://localhost:8080` for iOS simulator or a real device IP for physical devices.

**Android network permission** — ensure `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```
For HTTP (non-HTTPS) traffic on Android, also add `android:usesCleartextTraffic="true"` to the `<application>` tag or an `network_security_config.xml`.
