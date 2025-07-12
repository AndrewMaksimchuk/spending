## Receipt example

```
atb
18.07.2023 18:23:33
243.71
=
молоко
батон
морозиво
=
image=image_name_of_receipt_example_atb.26.09.2022.15.29.32.jpg
```

First 3 lines is required,  
all next, from line separetion, is optional.

Image of receipt must be saved to
`project_directory/receipts_images` directory.  
The best image name is: shop_name.date.time,
like in example above.

## Install

Run script `./install.bash` with `sudo` to see  
steps + create simlynk + shell completion(bash/zsh).

- Add to yout shell config file:  
  "SPENDING_INSTALL=path_to_this_directory"
- Then add "export PATH=$PATH:$SPENDING_INSTALL"
- Save and reload config file.
- Now you have 'spending' application.

## Service web server Node.js

You can run web server as `systemd` service.  
The service file is `spending.service`

### Commands for use service

`web_server_start` - start web server as service
`web_server_stop`  - stop web server as service

### systemctl commands

- Make systemd aware of the new service: sudo systemctl daemon-reload
- Make the service start on boot: sudo systemctl enable spending
- Start it with: systemctl start spending
- See logs with: journalctl -u spending

## Usage

See [usage](usage.md)

## Additional functions

###### Run only from this project directory

`show_last_n_days.bash` - Show last added  
receipts n days ago

## Statistics description(how to understand)

### Frequency table

Frequency means the number of times a value  
appears in the data. A table can quickly show us  
how many times each value appears.

### Relative frequency table

Relative frequency means the number of times a  
value appears in the data compared to the total  
amount. A percentage is a relative frequency.

### Cumulative frequency table

Cumulative frequency counts up to a particular  
value.

### Mean

The mean is usually referred to as 'the average'.

### Median

The median is the middle value in a data set  
ordered from low to high.

### Range

The range is the difference between the smallest  
and the largest value of the data.  
Range is the simplest measure of variation.
