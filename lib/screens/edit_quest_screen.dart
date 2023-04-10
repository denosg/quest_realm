import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quest.dart';
import '../providers/quest_provider.dart';
import '../providers/user_provider.dart';

class EditQuestScreen extends StatefulWidget {
  static const routeName = '/edit-quest';

  @override
  State<EditQuestScreen> createState() => _EditQuestScreenState();
}

class _EditQuestScreenState extends State<EditQuestScreen> {
  // we are going to use a form to get the data we need

  // temp quest
  var _editedQuest = Quest(id: '', title: '', description: '', points: 0);

  //form key
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;
  var _isInList = false;
  int initialPoints = 0;

  var _initValues = <String, dynamic>{
    'title': null,
    'description': null,
    'points': null,
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      // gets the id of the quest edited (already existing quest)
      final questId = ModalRoute.of(context)?.settings.arguments as String?;
      if (questId != null) {
        _isInList = true;
        final quest = Provider.of<QuestProvider>(context, listen: false)
            .findById(questId);
        _editedQuest = quest;
        _initValues = {
          'title': _editedQuest.title,
          'description': _editedQuest.description,
          'points': _editedQuest.points.toString(),
        };
        initialPoints = int.parse(_initValues['points']);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(String userKey) async {
    final isValid = _form.currentState?.validate();
    if (isValid == false || isValid == null) {
      return;
    }
    _form.currentState?.save();
    if (_editedQuest.id != '') {
      final userProvider = context.read<UserProvider>();

      // updates the existing quest
      await Provider.of<QuestProvider>(context, listen: false)
          .updateQuest(_editedQuest.id, _editedQuest);

      if (initialPoints > _editedQuest.points) {
        int addPoints = initialPoints - _editedQuest.points;
        // adds points since initial points > new amount of points for quest
        await userProvider.addPointsByAccQuest(addPoints, userKey);
      } else if (initialPoints < _editedQuest.points) {
        int removePoints = _editedQuest.points - initialPoints;
        // removes points since initial points < new amount of points for quest
        await userProvider.removePointsByCreateQuest(removePoints, userKey);
      }
    } else {
      try {
        // adds a new quest in the database
        context.read<QuestProvider>().addQuest(_editedQuest);

        // removes the points created by the quest
        context.read<UserProvider>().removePointsByCreateQuest(
              _editedQuest.points,
              userKey,
            );
        // error handling ->
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text('An error occured'),
                  content: const Text('Something went wrong'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ));
      }
    }
    // after saving the quest, the user is pushed to main screen
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isInList ? const Text('Edit quest') : const Text('Add quest'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, userData, _) => IconButton(
            onPressed: () => _saveForm(userData.user.userKey),
            icon: const Icon(
              Icons.save_alt,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                autocorrect: false,
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle:
                        TextStyle(color: Theme.of(context).accentColor)),
                textInputAction: TextInputAction.next,
                autofocus: true,
                // gets the introduced string
                onSaved: (title) {
                  if (title != null) {
                    _editedQuest = Quest(
                        id: _editedQuest.id,
                        title: title,
                        description: _editedQuest.description,
                        points: _editedQuest.points);
                  }
                },
                validator: (value) {
                  if (value == '') {
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                autocorrect: false,
                initialValue: _initValues['description'],
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                onSaved: (description) {
                  if (description != null) {
                    _editedQuest = Quest(
                        id: _editedQuest.id,
                        title: _editedQuest.title,
                        description: description,
                        points: _editedQuest.points);
                  }
                },
                validator: (value) {
                  if (value == '') {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Consumer<UserProvider>(
                builder: (context, userData, _) => TextFormField(
                  autocorrect: false,
                  initialValue: _initValues['points'],
                  decoration: const InputDecoration(
                    labelText: 'Points',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (points) {
                    if (points != null) {
                      _editedQuest = Quest(
                        id: _editedQuest.id,
                        title: _editedQuest.title,
                        description: _editedQuest.description,
                        points: int.parse(points),
                      );
                    }
                  },
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter the points';
                    }
                    if (value != null) {
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                    }
                    if (value != null) {
                      if (int.parse(value) <= 0) {
                        return 'Please enter a number > 0';
                      }
                    }
                    if (value != null) {
                      if (int.parse(value) > userData.user.points) {
                        return 'You don\'t have enough points !';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
