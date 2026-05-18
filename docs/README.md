# Login

iOS (SwiftUI) で Firebase Authentication と Google Sign-In を組み合わせたログインサンプルアプリです。

参考: [Firebase Authentication with Google Sign-In for iOS](https://firebase.google.com/docs/auth/ios/google-signin?hl=ja)

## 機能

- Google アカウントでのサインイン / サインアウト
- Firebase Auth の認証状態を `AsyncStream` で購読
- サインイン状態に応じた画面遷移（`LoginView` ↔ `MainView`）

## 必要環境

- iOS 26.4 以降（`IPHONEOS_DEPLOYMENT_TARGET = 26.4`）
- Swift 6.0
- Xcode 26 以降
- Firebase プロジェクト（Google プロバイダを有効化済み）

## セットアップ

1. Firebase コンソールで iOS アプリを登録し、`GoogleService-Info.plist` をダウンロードして `Login/` 配下に配置します。
2. Firebase Authentication の「ログイン方法」で Google を有効化します。
3. `GoogleService-Info.plist` 内の `REVERSED_CLIENT_ID` を `Info.plist` の `CFBundleURLTypes > CFBundleURLSchemes` に追加します。
4. 依存ライブラリは Swift Package Manager で以下を追加します。
   - [firebase-ios-sdk](https://github.com/firebase/firebase-ios-sdk) (`FirebaseAuth`)
   - [GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS) (`GoogleSignIn`)
5. `Login.xcodeproj` を Xcode で開き、実機またはシミュレータで実行します。

## プロジェクト構成

```
Login/
├── LoginApp.swift              // アプリのエントリポイント、Firebase 初期化と URL ハンドリング
├── GoogleService-Info.plist    // Firebase 設定（要差し替え）
├── Info.plist
├── Models/
│   └── AuthUser.swift          // FirebaseAuth.User をラップした Sendable な値型
├── Data/
│   └── AuthServiceProtocol.swift  // 認証ロジック (Google Sign-In + Firebase Auth)
└── Presentation/
    ├── AuthViewModel.swift     // @Observable ベースの ViewModel
    ├── LoginView.swift         // 未ログイン時の画面
    └── MainView.swift          // ログイン後の画面
```

## アーキテクチャ概要

- `AuthService` が `GIDSignIn` でトークンを取得し、`GoogleAuthProvider` の credential で Firebase にサインインします。
- `Auth.auth().addStateDidChangeListener` の結果を `AsyncStream<AuthUser?>` として公開します。
- `AuthViewModel` がそのストリームを購読し、`user` プロパティを更新します。
- `LoginApp` で `viewModel.user` の有無に応じて `LoginView` / `MainView` を切り替えます。

## 注意事項

- `GoogleService-Info.plist` は `.gitignore` で除外されています。各自の Firebase プロジェクトの設定ファイルを配置してください。
