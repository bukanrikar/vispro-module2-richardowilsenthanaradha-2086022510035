# Check Yourself Question/Answer

## 1. What is the difference between the Model, View, and ViewModel in this application?

in the most simple way too explain this is model is for database, views is for file that will be showed to user, and viewmodel is a place for the logic. model hold things like the book and loan, view hold the UI and design things, and the viewmodel connect those two.

## 2. What should happen if a student attempts to borrow a book that already has an active loan?

the viewmodel logic design will reject those attempt, theres OperationResult.failure for a reason, the rule prevent borrowing book that currently out on loan.

## 3. Why is it better to calculate the fine in one place rather than repeating the formula in multiple widgets?

- code now is easier to maintain.
- it prevent duplicated logic.
- make sure screen show the exact the same amount.

## 4. What is the difference between a book being Overdue and being Missing?

when book is overdue, it because it already past its due date but less than six months.
when book is missing, it because it already past more than six months since its due date.

## 5. If the university changes its weekly fine from Rp5,000 to Rp7,000, how should the app be updated?

if the university change its weekly fine to Rp7.000, the update only needed on FineCalculator. the weeklyFine one.
