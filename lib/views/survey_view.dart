import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/travel_viewmodel.dart';
import '../views/home_view.dart';
import '../views/welcome_view.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TravelViewModel>(
      builder: (context, viewModel, child) {
        final currentQuestion =
            viewModel.questions[viewModel.currentQuestionIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Anket'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Soru ${viewModel.currentQuestionIndex + 1}/${viewModel.questions.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  currentQuestion.question,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ...currentQuestion.options.map((option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () => viewModel.answerQuestion(option),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: (viewModel.currentQuestionIndex + 1) /
                      viewModel.questions.length,
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
