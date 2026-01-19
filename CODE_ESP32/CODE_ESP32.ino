#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>

#define RX_PIN 3                   
HardwareSerial STM8Serial(2); 

// --- BLE UUID (giữ nguyên) ---
#define SERVICE_UUID        "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"  // UART service
#define CHAR_RX_UUID        "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"  // app -> ESP32 (Write)
#define CHAR_TX_UUID        "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"  // ESP32 -> app (Notify)

BLEServer* pServer = nullptr;
BLECharacteristic* pTxCharacteristic = nullptr;
bool deviceConnected = false;

// Callback khi điện thoại (client) kết nối/ngắt
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    Serial.println("[BLE] Đã kết nối");
  }
  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    Serial.println("[BLE] Ngắt kết nối");
    // Quảng bá lại cho thiết bị khác kết nối
    pServer->getAdvertising()->start();
  }
};

class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) override {
    String rxValue = pCharacteristic->getValue();

    if (rxValue.length() > 0) {
      Serial.print("[BLE] Nhận từ app: ");
      Serial.println(rxValue);

      // Gửi phản hồi lại app (echo)
      String echo = "ESP32 OK: " + rxValue;
      if (pTxCharacteristic) {
        pTxCharacteristic->setValue(echo.c_str());
        pTxCharacteristic->notify();
      }
    }
  }
};

void setup() {
  Serial.begin(115200);
  delay(200);
  Serial.println("\n[SYS] ESP32 khởi động...");

  // UART2 nhận dữ liệu từ STM8
  STM8Serial.begin(9600, SERIAL_8N1, RX_PIN, TX_PIN);
  Serial.println("[UART] UART2 Started (RX = GPIO16)");

  // --- Khởi động BLE ---
  Serial.println("[BLE] Khởi động BLE...");
  BLEDevice::init("ESP32-BLE-Test"); // Tên thiết bị khi quét
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Tạo service
  BLEService* pService = pServer->createService(SERVICE_UUID);

  // TX: Notify về app
  pTxCharacteristic = pService->createCharacteristic(
      CHAR_TX_UUID,
      BLECharacteristic::PROPERTY_NOTIFY
  );
  pTxCharacteristic->addDescriptor(new BLE2902()); // Cho phép app bật Notify

  // RX: App ghi vào (Write)
  BLECharacteristic* pRxCharacteristic = pService->createCharacteristic(
      CHAR_RX_UUID,
      BLECharacteristic::PROPERTY_WRITE
  );
  pRxCharacteristic->setCallbacks(new MyCallbacks());

  pService->start();

  // Bắt đầu quảng bá
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();

  Serial.println("[BLE] Đang quảng bá, mở app để kết nối...");
}

void loop() {
  // --- Nhận dữ liệu từ STM8 và đẩy qua BLE ---
  if (STM8Serial.available() > 0) {
    String msg = STM8Serial.readStringUntil('\n');
    msg.trim();

    if (msg.length() > 0) {
      // In ra Serial
      Serial.print("[STM8] ");
      Serial.println(msg);

      // Nếu đang có app BLE kết nối -> gửi Notify chuỗi STM8
      if (deviceConnected && pTxCharacteristic) {
        pTxCharacteristic->setValue(msg.c_str());
        pTxCharacteristic->notify();
        Serial.print("[BLE] Sent to app: ");
        Serial.println(msg);
      }
    }
  }

}