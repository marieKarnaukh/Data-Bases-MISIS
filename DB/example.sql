
select * from fn_CreateScheduleForGroup('���-22-1');

select * from fn_GetStudentsByGroup('���-22-1');

EXEC pr_AddNewStudent '2004.10.01', '����', '������', '��������';

EXEC pr_TransferStudentToAnotherGroup 2208485, 1;

EXEC pr_TransferStudentToAnotherGroup 2200001, 1;