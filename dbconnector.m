

conn = database('project2','root','','Vendor','MySQL',...
                'Server','localhost')
            

%data fetch kore show korar jonnow . math lab e matrix hisabe show kore
curs = exec(conn,'select * from student');
curs = fetch(curs);
curs.Data
%%
text = 'onny';
disp(text)
SQL = ['select matchface from student where name like' '''' text ''''] ;
cx = exec(conn,SQL) ;
ss = fetch(cx) ;
ss.Data
%%
match = 0;
clause = ['where name = ' '''' text ''''] ;
col={'Attendance'};
val={match};
update(conn, 'student', col, val, clause) ;

%%
curs = exec(conn,'select * from student');
curs = fetch(curs);
curs.Data


%%
%data insert korar jonnow 
% prompt = 'For insert data to mysql';
% prompt = 'Input Name:';
% name = input(prompt,'s');
% prompt = 'Id:';
% id = input(prompt)
% prompt = 'Match Face? 0 for no and 1 for yes:';
% matchface = input(prompt)
% colnames={'name', 'id', 'matchface'};
% values={name, id, matchface};
% insert(conn, 'student',colnames, values )
% %update check
% curs = exec(conn,'select * from student');
% curs = fetch(curs);
% curs.Data
% 
% close(conn);

end
