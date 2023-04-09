import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:quest_realm/models/quest.dart';
import 'package:quest_realm/providers/quest_provider.dart';
import 'package:quest_realm/providers/user_provider.dart';

class EditQuestScreen extends StatefulWidget {
  static const routeName = '/edit-quest';

  @override
  State<EditQuestScreen> createState() => _EditQuestScreenState();
}

class _EditQuestScreenState extends State<EditQuestScreen> {
  // we are going to use a form to get the data we need
  // TODO: edit form to accept only points if you have more than how much you can give

  // temp quest
  var _editedQuest = Quest(id: '', title: '', description: '', points: 0);

  //form key
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;
  var _isInList = false;

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
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid == false || isValid == null) {
      return;
    }
    _form.currentState?.save();
    if (_editedQuest.id != '') {
      // updates the existing quest
      await Provider.of<QuestProvider>(context, listen: false)
          .updateQuest(_editedQuest.id, _editedQuest);
    } else {
      try {
        // adds a new quest in the database
        await Provider.of<QuestProvider>(context, listen: false)
            .addQuest(_editedQuest);
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isInList ? Text('Edit quest') : Text('Add quest'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButton(
          onPressed: _saveForm,
          icon: const Icon(
            Icons.save_alt,
          )),
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
