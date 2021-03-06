SET SCHEMA FN71878@


-- RETURNS SUMPOINTS OF PARTICIPANT WITH ID = v_id    -- WORKS
CREATE FUNCTION GET_POINTS(v_id INTEGER)
RETURNS INT
SPECIFIC GET_POINTS
BEGIN ATOMIC
	DECLARE V_POINTS INTEGER;
	DECLARE V_ERROR VARCHAR(64);
	SET V_POINTS= (SELECT SUMPOINTS
					FROM PARTICIPANTS
					WHERE PARTICIPANT_ID=v_id);
	SET V_ERROR = 'ERROR: PERSON' || V_ID || 'WAS NOT FOUND';
	IF V_POINTS IS NULL THEN SIGNAL SQLSTATE '80000' SET MESSAGE_TEXT=V_ERROR;
	END IF;
RETURN V_POINTS;
END@

VALUES FN71878.GET_POINTS(12)@

DROP FUNCTION GET_POINTS@

-- RETURNS TABLE WITH INFO FOR PARTICIPANT WITH PROPER NAME    --WORKS
CREATE FUNCTION INFO_PARTICIPANT(v_id INTEGER)
RETURNS TABLE (NAME VARCHAR(64), SEASON_ID INTEGER, AGE INTEGER)
	RETURN 
		SELECT PEOPLE.PERSON_NAME AS NAME, PARTICIPATE_IN.SEASON_ID AS SEASON, PEOPLE.AGE AS AGE
		FROM PARTICIPATE_IN, PEOPLE, PARTICIPANTS
		WHERE PARTICIPATE_IN.PERSON_ID = v_id AND v_id=PARTICIPANTS.PARTICIPANT_ID AND PEOPLE.PERSON_ID=v_id@
		
SELECT * FROM TABLE(FN71878.INFO_PARTICIPANT(20)) T@

DROP FUNCTION INFO_PARTICIPANT@