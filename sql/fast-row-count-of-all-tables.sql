select t.name TableName, sum(p.rows) Rows
from sys.tables t, sys.partitions p
where p.object_id = t.object_id
    and t.is_ms_shipped = 0
    and p.index_id in (1, 0)
    and t.type = 'u'
group by t.name 
order by sum(p.rows) desc
