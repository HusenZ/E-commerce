import 'dart:async';
import 'package:daprot_v1/bloc/update_user_bloc/update_user_state.dart';
import 'package:daprot_v1/domain/model/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../update_user_bloc/update_event_event.dart';

class UserUpdateBloc extends Bloc<UserUpdateEvent, UserUpdateState> {
  static final _userUpdateController = StreamController<UserModel>.broadcast();

  static Stream<UserModel>? get userUpdateStream =>
      _userUpdateController.stream;

  UserUpdateBloc() : super(UserUpdateInitial()) {
    on<UpdateUserEvent>((event, emit) async {
      try {
        emit(UserUpdateLoading());
        String profileImgURL = event.newProfileImagePath;
        print("In bloc");
        print(event.isProfileUpdated);
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        if (event.isProfileUpdated) {
          Reference refImage =
              FirebaseStorage.instance.ref('user_profile/${event.userId}.jpg');

          await refImage.putFile(File(event.newProfileImagePath));
          profileImgURL = await refImage.getDownloadURL();
        } else {
          await firestore.collection('Users').doc(event.userId).update({
            'name': event.name,
            'imgUrl': profileImgURL,
            'email': event.email,
            // 'bio': event.bio,
          });
        }

        emit(UserUpdateSuccess());
        // Create a stream controller to broadcast updates

        // Expose the stream

        @override
        Future<void> close() {
          _userUpdateController.close();
          return super.close();
        }

        print("User Updated!");
      } catch (e) {
        print("Some error occurred $e");
        emit(const UserUpdateFailure("Failed to update user."));
      }
    });
  }
}
