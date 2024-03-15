package com.all.document.reader.office.docs.viewer.app;

// android/app/src/main/java/com/example/my_flutter_project/MainActivity.java
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "file_lister";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("listFilesByExtension")) {
                                String extension = call.arguments.toString();
                                List<String> filesList = listFilesByExtension(getApplicationContext(), extension);
                                result.success(filesList);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private List<String> listFilesByExtension(Context context, String extension) {
        List<String> filesList = new ArrayList<>();
        try {
            Uri queryUri = MediaStore.Files.getContentUri("external");
            String[] projection = {MediaStore.Files.FileColumns.DATA};

            String selection = MediaStore.Files.FileColumns.DATA + " like ? ";
            String[] selectionArgs = new String[]{"%." + extension};

            try (Cursor cursor = context.getContentResolver().query(
                    queryUri,
                    projection,
                    selection,
                    selectionArgs,
                    null
            )) {
                if (cursor != null) {
                    while (cursor.moveToNext()) {
                        String filePath = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA));
                        filesList.add(filePath);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return filesList;
    }
}
