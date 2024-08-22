local Job = require 'plenary.job'

-- Function to decode base64 for the current line
function base64DecodeCurrentLine()
  local current_line = vim.api.nvim_get_current_line()

  -- Create a job to run the 'base64 -d' command
  local job = Job:new {
    command = 'base64',
    args = { '-d' },
    writer = current_line, -- Send the current line as input
  }

  local decrypt_job = Job:new {
    command = 'openssl',
    args = { 'enc', '-aes-256-cbc', '-d', '-iter', '<actual_iter>', '-pbkdf2',
      '-S', '<actual_seed>', '-iv', '<actual_iv>', '-k', '<actual_pw>' },
    writer = job
  }

  local decoded_line = ""

  -- Define a callback to handle the decoded output
  local on_exit = function(j, return_val)
    if return_val == 0 then
      decoded_line = j:result()[1]
    else
    end
  end
  -- Start the job and set the exit callback
  decrypt_job:after(on_exit)
  decrypt_job:sync()
  vim.api.nvim_set_current_line(decoded_line)
end

-- Map a key to invoke the base64DecodeCurrentLine function
vim.api.nvim_set_keymap('n', '<leader>bd', [[:lua base64DecodeCurrentLine()<CR>]], { noremap = true, silent = true })
