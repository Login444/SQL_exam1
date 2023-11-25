CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUserProc`(user_id_del INT)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    
    BEGIN
        ROLLBACK;
    END;

	START TRANSACTION;
    
		DELETE 
        FROM likes l
		WHERE l.user_id = user_id_del;
    
		DELETE 
        FROM users_communities uc
		WHERE uc.user_id = user_id_del;
    
		DELETE 
        FROM messages m
		WHERE m.to_user_id = user_id_del 
            OR m.from_user_id = user_id_del;
    
		DELETE 
        FROM friend_requests fr
		WHERE fr.initiator_user_id = user_id_del 
            OR fr.target_user_id = user_id_del;
    
		DELETE l
		FROM media m
		JOIN likes l ON l.media_id = m.id
		WHERE m.user_id = user_id_del;
    
		UPDATE profiles p
		JOIN media m ON p.photo_id = m.id
		SET p.photo_id = NULL
		WHERE m.user_id = user_id_del;

		DELETE 
        FROM media m
		WHERE m.user_id = user_id_del;
    
		DELETE 
        FROM profiles p
		WHERE p.user_id = user_id_del;
    
		DELETE 
        FROM users u
		WHERE u.id = user_id_del;
         
	COMMIT;

END