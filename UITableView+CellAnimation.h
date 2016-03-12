typedef enum
{
    UITableViewAnimationDirectionFromLeft,
    UITableViewAnimationDirectionFromRight
}UITableViewAnimationDirection;

@interface UITableView (CellAnimation)

- (void)animateRowsFromLeft;
- (void)animateRowsFromRight;

@end